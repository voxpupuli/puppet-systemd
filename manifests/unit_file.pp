# -- Define: systemd::unit_file
# Creates a unit file and reloads systemd
define systemd::unit_file(
  $ensure = file,
  $path = '/etc/systemd/system',
  $content = undef,
  $source = undef,
  $settings = undef,
  $target = undef,
) {
  include ::systemd

  if $settings and $source {
    fail('You may not supply both settings and source parameters to systemd::unit_file')
  }
  if $settings and $content {
    fail('You may not supply both settings and content parameters to systemd::unit_file')
  }

  if $settings {
    validate_hash($settings)
    $_content = template('systemd/unit_file.erb')
  } elsif $content {
    $_content = $content
  } else {
    $_content = undef
  }

  file { "${path}/${title}":
    ensure  => $ensure,
    content => $_content,
    source  => $source,
    target  => $target,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Exec['systemctl-daemon-reload'],
  }
}
