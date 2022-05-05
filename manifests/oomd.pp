# @api private
# @summary This class manages and configures oomd.
# @see https://www.freedesktop.org/software/systemd/man/oomd.conf.html
class systemd::oomd {
  assert_private()

  service { 'systemd-oomd':
    ensure => running,
    enable => true,
  }
  $systemd::oomd_settings.each |$option, $value| {
    ini_setting {
      $option:
        path    => '/etc/systemd/oomd.conf',
        section => 'OOM',
        setting => $option,
        notify  => Service['systemd-oomd'],
    }
    if $value =~ Hash {
      Ini_setting[$option] {
        * => $value,
      }
    } else {
      Ini_setting[$option] {
        value   => $value,
      }
    }
  }
}
