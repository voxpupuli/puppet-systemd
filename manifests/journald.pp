# @api private
# @summary This class manages and configures journald.
# @see https://www.freedesktop.org/software/systemd/man/journald.conf.html
class systemd::journald {
  assert_private()

  service { 'systemd-journald':
    ensure => running,
  }
  if !empty($systemd::journald_settings) {
    file { '/etc/systemd/journald.conf.d':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }
  $systemd::journald_settings.each |$option, $value| {
    ini_setting {
      $option:
        path    => '/etc/systemd/journald.conf.d/puppet.conf',
        section => 'Journal',
        setting => $option,
        notify  => Service['systemd-journald'],
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
