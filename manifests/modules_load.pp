# Creates a modules-load.d drop file
#
# @api public
#
# @see modules-load.d(5)
#
# @param filename
#   The name of the modules-load.d file to create
#
# @param ensure
#   Whether to drop a file or remove it
#
# @param path
#   The path to the main systemd modules-load.d directory
#
# @param content
#   The literal content to write to the file
#
#   * Mutually exclusive with ``$source``
#
# @param source
#   A ``File`` resource compatible ``source``
#
#   * Mutually exclusive with ``$content``
#
# @example load a module
#   systemd::modules_load{'impi.conf':
#      content => "ipmi\n",
#   }
#
# @example override /lib/modules-load.d/myservice.conf in /etc/modules-load.d/myservice.conf
#   systemd::modules_load{'myservice.conf':
#      content => "# Cancel system version of the file\n",
#   }
#
define systemd::modules_load (
  Enum['present', 'absent', 'file'] $ensure   = 'file',
  Systemd::Dropin                   $filename = $name,
  Stdlib::Absolutepath              $path     = '/etc/modules-load.d',
  Optional[String[1]]               $content  = undef,
  Optional[String[1]]               $source   = undef,
) {
  include systemd::modules_loads

  $_tmp_file_ensure = $ensure ? {
    'present' => 'file',
    default   => $ensure,
  }

  file { "${path}/${filename}":
    ensure  => $_tmp_file_ensure,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Class['systemd::modules_loads'],
  }
}
