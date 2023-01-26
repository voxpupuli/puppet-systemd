# @api private
# @summary This class manages systemd's machine-info file (hostnamectl)
# @see https://www.freedesktop.org/software/systemd/man/machine-info.html
class systemd::machine_info {
  assert_private()

  $systemd::machine_info_settings.each |$option, $value| {
    shellvar { $option:
      ensure => 'present',
      target => '/etc/machine-info',
      value  => $value,
    }
  }
}
