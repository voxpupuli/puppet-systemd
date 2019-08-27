# Creates a systemd tmpfile
#
# @api public
#
# @see systemd-tmpfiles(8)
#
# @attr name [Pattern['^[^/]+\.conf$']] (filename)
#   The name of the tmpfile to create
#
# @param $ensure
#   Whether to drop a file or remove it
#
# @param path
#   The path to the main systemd tmpfiles directory
#
# @param content
#   The literal content to write to the file
#
#   * Mutually exclusive with ``$source``
#
# @param source
#   A ``File`` resource compatible ``source``
#
#  * Mutually exclusive with ``$limits``
#
define systemd::tmpfile(
  Enum['present', 'absent', 'file'] $ensure   = 'file',
  Systemd::Dropin                   $filename = $name,
  Stdlib::Absolutepath              $path     = '/etc/tmpfiles.d',
  Optional[String]                  $content  = undef,
  Optional[String]                  $source   = undef,
) {
  include systemd::tmpfiles

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
    notify  => Class['systemd::tmpfiles'],
  }
}
