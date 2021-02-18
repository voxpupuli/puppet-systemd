# @api private
#
# This class provides a solution to enable accounting
#
class systemd::system {
  assert_private()

  $systemd::accounting.each |$option, $value| {
    systemd::systemctl::daemon_reload { $option: }
    ini_setting { $option:
      ensure  => 'present',
      path    => '/etc/systemd/system.conf',
      section => 'Manager',
      setting => $option,
      value   => $value,
      notify  => Systemd::Systemctl::Daemon_reload[$option],
    }
  }
}
