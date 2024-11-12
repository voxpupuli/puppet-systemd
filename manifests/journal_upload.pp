# @api private
# @summary This class manages and configures journal-upload.
# @see https://www.freedesktop.org/software/systemd/man/journald.conf.html
#
# @param package_name
#  name of the package to install for the functionality
#
# @param service_ensure
#  what we ensure for the service
#
# @param service_enable
#  to enable the service
#
class systemd::journal_upload (
  Optional[String[1]]       $package_name   = undef,
  Enum['running','stopped'] $service_ensure = 'running',
  Boolean                   $service_enable = true,
) {
  assert_private()

  if $package_name {
    stdlib::ensure_packages($package_name)
  }

  service { 'systemd-journal-upload':
    ensure => $service_ensure,
    enable => $service_enable,
  }
  $systemd::journal_upload_settings.each |$option, $value| {
    ini_setting { "journal-upload_${option}":
      path    => '/etc/systemd/journal-upload.conf',
      section => 'Upload',
      setting => $option,
      notify  => Service['systemd-journal-upload'],
    }
    if $value =~ Systemd::JournaldSettings::Ensure {
      Ini_setting["journal-upload_${option}"] {
        * => $value,
      }
    } else {
      Ini_setting["journal-upload_${option}"] {
        value   => $value,
      }
    }
  }
}
