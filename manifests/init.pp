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
# @param resolved_ensure
#   The state that the ``resolved`` service should be in
#
# @param manage_networkd
#   Manage the systemd network daemon
#
# @param networkd_ensure
#   The state that the ``networkd`` service should be in
#
class systemd (
  Optional[Systemd::ServiceLimits] $service_limits  = undef,
  Boolean                          $manage_resolved = false,
  Enum['stopped','running']        $resolved_ensure = 'running',
  Boolean                          $manage_networkd = false,
  Enum['stopped','running']        $networkd_ensure = 'running',
){

  contain ::systemd::systemctl::daemon_reload

  if $service_limits {
    create_resources('systemd::service_limits', $service_limits)
  }

  if $manage_resolved {
    contain ::systemd::resolved
  }

  if $manage_networkd {
    contain ::systemd::networkd
  }
}
