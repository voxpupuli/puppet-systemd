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
# @param manage_timesyncd
#   Manage the systemd tiemsyncd daemon
#
# @param timesyncd_ensure
#   The state that the ``timesyncd`` service should be in
#
# @param ntp_server
#   comma separated list of ntp servers, will be combined with interface specific
#   addresses from systemd-networkd. requires puppetlabs-inifile
#
# @param fallback_ntp_server
#   A space-separated list of NTP server host names or IP addresses to be used
#   as the fallback NTP servers. Any per-interface NTP servers obtained from
#   systemd-networkd take precedence over this setting. requires puppetlabs-inifile
class systemd (
  Hash[String, Hash[String, Any]]  $service_limits   = {},
  Boolean                          $manage_resolved  = false,
  Enum['stopped','running']        $resolved_ensure  = 'running',
  Boolean                          $manage_networkd  = false,
  Enum['stopped','running']        $networkd_ensure  = 'running',
  Boolean                          $manage_timesyncd = false,
  Enum['stopped','running']        $timesyncd_ensure = 'running',
  Optional[Variant[Array,String]] $ntp_server          = undef,
  Optional[Variant[Array,String]] $fallback_ntp_server = undef,
){

  contain ::systemd::systemctl::daemon_reload

  create_resources('systemd::service_limits', $service_limits)

  if $manage_resolved and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-resolved.service'] {
    contain ::systemd::resolved
  }

  if $manage_networkd and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-networkd.service'] {
    contain ::systemd::networkd
  }

  if $manage_timesyncd and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-timesyncd.service'] {
    contain ::systemd::timesyncd
  }
}
