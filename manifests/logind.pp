# @api private
#
# This class manages systemd's login manager configuration.
#
# https://www.freedesktop.org/software/systemd/man/logind.conf.html
class systemd::logind {

  assert_private()

  service{'systemd-logind':
    ensure => running,
  }
  $systemd::logind_settings.each |$option, $value| {
    ini_setting{
      $option:
        path    => '/etc/systemd/logind.conf',
        section => 'Login',
        setting => $option,
        notify  => Service['systemd-logind'],
    }
    if $value =~ Hash {
      Ini_setting[$option]{
        * => $value,
      }
    } else {
      Ini_setting[$option]{
        value   => $value,
      }
    }
  }
}
