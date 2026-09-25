# @api private
# @summary This class manages and configures sleep.conf.
# @see https://www.freedesktop.org/software/systemd/man/systemd-sleep.conf.html
class systemd::sleep {
  assert_private()

  if $systemd::sleep_use_etc_conf {
    $systemd::sleep_settings.each |$option, $value| {
      ini_setting {
        $option:
          path    => '/etc/systemd/sleep.conf',
          section => 'Sleep',
          setting => $option,
          notify  => Systemd::Daemon_reexec['sleep.conf'],
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
}
