# -- Define: systemd::network
# Creates network config for systemd-networkd
define systemd::network (
  Enum['file', 'absent'] $ensure         = file,
  Stdlib::Absolutepath $path             = '/etc/systemd/network',
  Optional[String] $content              = undef,
  Optional[String] $source               = undef,
  Optional[Stdlib::Absolutepath] $target = undef,
  Boolean $restart_service               = true,
){

  include ::systemd

  if $restart_service and $systemd::manage_networkd {
    $notify = Service['systemd-networkd']
  } else {
    $notify = undef
  }

  file { "${path}/${name}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    target  => $target,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => $notify,
  }
}
