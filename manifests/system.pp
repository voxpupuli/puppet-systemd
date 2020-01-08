# **NOTE: THIS IS A [PRIVATE](https://github.com/puppetlabs/puppetlabs-stdlib#assert_private) CLASS**
#
# This class provides a solution to enable accounting
#
class systemd::system (
  Hash[String,String] $accounting = $systemd::accounting
) {

  assert_private()

  $accounting.each |$option, $value| {
    ini_setting{$option:
      ensure  => 'present',
      path    => '/etc/systemd/system.conf',
      section => 'Manager',
      setting => $option,
      value   => $value,
      notify  => Class['systemd::systemctl::daemon_reload'],
    }
  }
}
