# This module allows triggering systemd commands once for all modules
#
# @api public
#
# @param service_limits
#   May be passed a resource hash suitable for passing directly into the
#   ``create_resources()`` function as called on ``systemd::service_limits``
#
# @param manage_resolved
#   Manage the systemd resolver
#
# @param resolvd_ensure
#   The state that the ``resolvd`` service should be in
#
# @param manage_networkd
#   Manage the systemd network daemon
#
# @param networkd_ensure
#   The state that the ``networkd`` service should be in
#
class systemd (
  Optional[Hash]                             $service_limits  = undef,
  Boolean                                    $manage_resolved = true,
  Variant[Enum['stopped','running'],Boolean] $resolvd_ensure  = 'running',
  Boolean                                    $manage_networkd = true,
  Variant[Enum['stopped','running'],Boolean] $networkd_ensure = 'running',
){

  contain ::systemd::systemctl::daemon_reload

  if $service_limits {
    create_resources('systemd::service_limits', $service_limits)
  }

  if $manage_resolved {
    $_enable_resolvd = $resolvd_ensure ? {
      /stopped/ => false,
      /running/ => true,
      default   => $resolvd_ensure
    }

    service{ 'systemd-resolved':
      ensure => $resolvd_ensure,
      enable => $_enable_resolvd
    }
    -> file{ '/etc/resolv.conf':
      ensure => 'symlink',
      target => '/run/systemd/resolve/resolv.conf'
    }
  }

  if $manage_networkd {
    $_enable_networkd = $networkd_ensure ? {
      /stopped/ => false,
      /running/ => true,
      default   => $networkd_ensure
    }

    service{ 'systemd-networkd':
      ensure => $networkd_ensure,
      enable => $_enable_networkd
    }
  }
}
