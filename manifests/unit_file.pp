# -- Define: systemd::unit_file
# Creates a unit file and reloads systemd
define systemd::unit_file(
  $ensure = file,
  $path = '/etc/systemd/system',
  $content = undef,
  $source = undef,
  $target = undef,
) {
  include ::systemd

  if $title =~ /^([^\/]+)\// {
    $subdir = $1
    if $subdir !~ /\.d$/ {
      fail("drop-in unit dirs must have suffix .d")
    }
    if $title !~ /\.conf$/ {
      fail("drop-in unit files must have suffix .conf")
    }
    file { "${path}/${subdir}":
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }
  }

  file { "${path}/${title}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    target  => $target,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Exec['systemctl-daemon-reload'],
  }
}
