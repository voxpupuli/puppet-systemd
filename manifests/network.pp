# @summary Creates network config for systemd-networkd
define systemd::network (
  Enum['file', 'absent']         $ensure          = file,
  Stdlib::Absolutepath           $path            = '/etc/systemd/network',
  Optional[String]               $content         = undef,
  Optional[String]               $source          = undef,
  Optional[Stdlib::Absolutepath] $target          = undef,
  String                         $owner           = 'root',
  String                         $group           = 'root',
  String                         $mode            = '0444',
  Boolean                        $show_diff       = true,
  Boolean                        $restart_service = true,
) {
  include systemd

  if $restart_service and $systemd::manage_networkd {
    $notify = Service['systemd-networkd']
  } else {
    $notify = undef
  }

  if $ensure == 'file' {
    if $content =~ Undef and $source =~ Undef {
      fail('Either content or source must be set but not both')
    }
    if $content =~ NotUndef and $source =~ NotUndef {
      fail('you can only set $content or $source')
    }
  }
  file { "${path}/${name}":
    ensure    => $ensure,
    content   => $content,
    source    => $source,
    target    => $target,
    owner     => $owner,
    group     => $group,
    mode      => $mode,
    show_diff => $show_diff,
    notify    => $notify,
  }
}
