# -- Define: systemd::service_limits
# Creates a custom config file and reloads systemd
define systemd::service_limits(
  $ensure          = file,
  $path            = '/etc/systemd/system',
  $limits          = undef,
  $source          = undef,
  $restart_service = true
) {
  include ::systemd

  if $limits {
    validate_hash($limits)
    $content = template('systemd/limits.erb')
  }
  else {
    $content = undef
  }

  if $limits and $source {
    fail('You may not supply both limits and source parameters to systemd::service_limits')
  } elsif $limits == undef and $source == undef {
    fail('You must supply either the limits or source parameter to systemd::service_limits')
  }

  file { "${path}/${title}.d/":
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }
  ->
  file { "${path}/${title}.d/limits.conf":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Exec['systemctl-daemon-reload'],
  }

  if $restart_service {
    exec { "systemctl restart ${title}":
      path        => $::path,
      refreshonly => true,
      subscribe   => File["${path}/${title}.d/limits.conf"],
      require     => Exec['systemctl-daemon-reload'],
    }
  }
}
