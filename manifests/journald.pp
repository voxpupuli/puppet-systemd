# **NOTE: THIS IS A [PRIVATE](https://github.com/puppetlabs/puppetlabs-stdlib#assert_private) CLASS**
#
# This class provides a solution to enable accounting
#
# https://www.freedesktop.org/software/systemd/man/journald.conf.html
class systemd::journald {

  assert_private()

  if $systemd::journald_persist_log {
    $journald_dir = 'directory'
  } else {
    $journald_dir = 'absent'
  }

  file { '/var/log/journal':
    ensure => $journald_dir,
    force  => true,
    owner  => 'root',
    group  => 'systemd-journal',
    mode   => '2755',
  }

  service{'systemd-journald':
    ensure => running,
  }
  $systemd::journald_settings.each |$option, $value| {
    ini_setting{
      $option:
        path    => '/etc/systemd/journald.conf',
        section => 'Journal',
        setting => $option,
        notify  => Service['systemd-journald'],
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
