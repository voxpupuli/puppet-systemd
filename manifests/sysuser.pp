# @summary Creates a sysusers.d configuration file
#
# @see systemd-sysusers(8)
# @see sysusers.d(5)
#
# @param filename
#   The name of the sysusers file to create
#
# @param ensure
#   Whether to drop a file or remove it
#
# @param path
#   The path to the main systemd sysusers.d directory
#
# @param content
#   The literal content to write to the file
#
#   * Mutually exclusive with `$source`
#
# @param source
#   A `File` resource compatible ``source``
#
# @param validate
#   Validate the file `systemd-sysusers --dry-run`, The parameter is ignored for systemd version less than 250 where validation is not available.
#
# @example Add a user with systemd-sysusers
#   systemd::sysuser { 'plato':
#     content => 'u plato - "be kind"',
#   }
#
# @example Manage /etc/sysusers.d directory with purge disabled
#   class { 'systemd::sysusers:
#     purgedir => false,
#   }
#   systemd::sysuser { 'plato':
#     content => 'u plato - "be kind"',
#   }
#
define systemd::sysuser (
  Enum['present', 'absent'] $ensure = 'present',
  Systemd::Dropin $filename = $name,
  Stdlib::Absolutepath $path = '/etc/sysusers.d',
  Boolean $validate = true,
  Optional[String] $content = undef,
  Optional[String] $source = undef,
) {
  include systemd::sysusers

  $_sysusers_file_ensure = $ensure ? {
    'present' => 'file',
    default   => $ensure,
  }

  $_validate_cmd = ($validate and Integer($facts['systemd_version']) >= 250 and $ensure == 'present') ? {
    true    => '/usr/bin/systemd-sysusers --dry-run %',
    default => undef,
  }

  file { "${path}/${filename}":
    ensure       => $_sysusers_file_ensure,
    content      => $content,
    validate_cmd => $_validate_cmd,
    source       => $source,
    owner        => 'root',
    group        => 'root',
    mode         => '0444',
    notify       => Exec['systemd-sysusers'],
  }
}
