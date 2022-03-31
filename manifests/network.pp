# @summary Creates network config for systemd-networkd
#
# @param ensure configure if the file should be configured or deleted
# @param path directory where the network configs are stored
# @param content the content of the file
# @param source a path to a file that's used as source
# @param target optional absolute path  in case the file should be stored somewhere else
# @param owner the user who owns the file
# @param group the group that owns the file
# @param mode the mode of the file
# @param show_diff whether the file diff should be shown on modifications
# @param restart_service whether systemd-networkd should be restarted on changes, defaults to true. `$systemd::manage_networkd` needs to be true as well
#
# @author Tim Meusel <tim@bastelfreak.de>
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

  if $restart_service and $systemd::manage_networkd and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-networkd.service'] {
    $notify = Service['systemd-networkd']
  } else {
    $notify = undef
  }

  if $ensure == 'file' {
    if $content =~ Undef and $source =~ Undef {
      fail('Either content or source must be set')
    }
    if $content =~ NotUndef and $source =~ NotUndef {
      fail('Either content or source must be set but not both')
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
