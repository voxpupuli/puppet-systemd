# @api private
# @summary This class manages and configures journal-upload.
# @see https://www.freedesktop.org/software/systemd/man/journald.conf.html
#
# @param package_name
#  name of the package to install for the functionality
#
class systemd::journal_upload (
  Optional[String[1]] $package_name = undef,
) {
  assert_private()

  if $package_name {
    stdlib::ensure_packages($package_name)
  }

  service { 'systemd-journal-upload':
    ensure => running,
  }
  $systemd::journal_upload_settings.each |$option, $value| {
    ini_setting { $option:
      path    => '/etc/systemd/journal-upload.conf',
      section => 'Upload',
      setting => $option,
      notify  => Service['systemd-journal-upload'],
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
