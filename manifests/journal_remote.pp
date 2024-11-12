# @api private
# @summary This class manages and configures journal-remote.
# @see https://www.freedesktop.org/software/systemd/man/journal-remote.conf.html
#
# @param package_name
#  name of the package to install for the functionality
#
class systemd::journal_remote (
  Optional[String[1]] $package_name = undef,
) {
  assert_private()

  if $package_name {
    stdlib::ensure_packages($package_name)
  }

  service { 'systemd-journal-remote':
    ensure => running,
    enable => true,
  }
  $systemd::journal_remote_settings.each |$option, $value| {
    ini_setting { "journal-remote_${option}":
      path    => '/etc/systemd/journal-remote.conf',
      section => 'Remote',
      setting => $option,
      notify  => Service['systemd-journal-remote'],
    }
    if $value =~ Systemd::JournaldSettings::Ensure {
      Ini_setting["journal-remote_${option}"] {
        * => $value,
      }
    } else {
      Ini_setting["journal-remote_${option}"] {
        value   => $value,
      }
    }
  }
}
