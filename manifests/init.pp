# This module allows triggering systemd commands once for all modules
#
# @api public
#
# @param service_limits
#   May be passed a resource hash suitable for passing directly into the
#   ``create_resources()`` function as called on ``systemd::service_limits``
#
class systemd (
  Optional[Hash] $service_limits = undef
  Boolean $manage_resolved = true,
  Boolean $manage_networkd = true,
){

  contain systemd::systemctl::daemon_reload

  if $service_limits {
    create_resources('systemd::service_limits', $service_limits)
  }

  if $manage_resolved {
    service{'systemd-resolved':
      ensure => 'running',
      enable => true,
    }
    -> file{'/etc/resolv.conf':
      ensure => 'symlink',
      target => '/run/systemd/resolve/resolv.conf',
    }
  }

  if $manage_networkd {
    service{'systemd-networkd':
      ensure => 'running',
      enable => true,
    }
  }
}
