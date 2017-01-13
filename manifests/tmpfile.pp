# Creates a systemd tmpfile
#
# @api public
#
# @see systemd-tmpfiles(8)
#
# @attr name [String]
#   The name of the tmpfile to create
#
#   * May not contain ``/``
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
  Enum['file','absent'] $ensure  = 'file',
  Stdlib::Absolutepath  $path    = '/etc/tmpfiles.d',
  Optional[String]      $content = undef,
  Optional[String]      $source  = undef,
) {
  include ::systemd

  if name =~ Pattern['/'] {
    fail('$name may not contain a forward slash "(/)"')
  }

  file { "${path}/${title}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['systemd::tmpfiles'],
  }
}
