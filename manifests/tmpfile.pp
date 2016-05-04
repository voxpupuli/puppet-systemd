# -- Define: systemd::tmpfile
# Creates a tmpfile and reloads systemd
define systemd::tmpfile(
  $ensure = file,
  $path = '/etc/tmpfiles.d',
  $content = undef,
  $source = undef,
) {
  include ::systemd

  file { "${path}/${title}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Exec['systemd-tmpfiles-create'],
  }
}