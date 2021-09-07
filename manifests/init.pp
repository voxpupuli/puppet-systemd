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
# @param dns
#   A space-separated list of IPv4 and IPv6 addresses to use as system DNS servers.
#   DNS requests are sent to one of the listed DNS servers in parallel to suitable
#   per-link DNS servers acquired from systemd-networkd.service(8) or set at runtime
#   by external applications. requires puppetlabs-inifile
#
# @param fallback_dns
#   A space-separated list of IPv4 and IPv6 addresses to use as the fallback DNS
#   servers. Any per-link DNS servers obtained from systemd-networkd take
#   precedence over this setting. requires puppetlabs-inifile
#
# @param domains
#   A space-separated list of domains host names or IP addresses to be used
#   systemd-resolved take precedence over this setting.
#
# @param llmnr
#   Takes a boolean argument or "resolve".
#
# @param multicast_dns
#   Takes a boolean argument or "resolve".
#
# @param dnssec
#   Takes a boolean argument or "allow-downgrade".
#
# @param dnsovertls
#   Takes a boolean argument or one of "yes", "opportunistic" or "no". "true" corresponds to
#   "opportunistic" and "false" (default) to "no".
#
# @param cache
#   Takes a boolean argument or "no-negative".
#
# @param dns_stub_listener
#   Takes a boolean argument or one of "udp" and "tcp".
#
# @param use_stub_resolver
#   Takes a boolean argument. When "false" (default) it uses /run/systemd/resolve/resolv.conf
#   as /etc/resolv.conf. When "true", it uses /run/systemd/resolve/stub-resolv.conf
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
#
# @param manage_journald
#   Manage the systemd journald
#
# @param journald_settings
#   Config Hash that is used to configure settings in journald.conf
#
# @param manage_udevd
#   Manage the systemd udev daemon
#
# @param udev_log
#   The value of /etc/udev/udev.conf udev_log
#
# @param udev_children_max
#   The value of /etc/udev/udev.conf children_max
#
# @param udev_exec_delay
#   The value of /etc/udev/udev.conf exec_delay
#
# @param udev_event_timeout
#   The value of /etc/udev/udev.conf event_timeout
#
# @param udev_resolve_names
#   The value of /etc/udev/udev.conf resolve_names
#
# @param udev_timeout_signal
#   The value of /etc/udev/udev.conf timeout_signal
#
# @param udev_rules
#   Config Hash that is used to generate instances of our
#   `udev::rule` define.
#
# @param manage_logind
#   Manage the systemd logind
#
# @param logind_settings
#   Config Hash that is used to configure settings in logind.conf
#
# @param loginctl_users
#   Config Hash that is used to generate instances of our type
#   `loginctl_user`.
#
# @param dropin_files
#   Configure dropin files via hiera with factory pattern
#
# @param manage_all_network_files
#
# @param network_path
#   where all networkd files are placed in
#
# @param manage_accounting
#   when enabled, the different accounting options (network traffic, IO, CPU util...) are enabled for units
#
# @param accounting
#   Hash of the different accounting options. This highly depends on the used systemd version. The module provides sane defaults per operating system using Hiera.
#
# @param purge_dropin_dirs
#   When enabled, unused directories for dropin files will be purged
#
class systemd (
  Hash[String,String]                                 $accounting,
  Hash[String,Hash[String, Any]]                      $service_limits = {},
  Boolean                                             $manage_resolved = false,
  Enum['stopped','running']                           $resolved_ensure = 'running',
  Optional[Variant[Array[String],String]]             $dns = undef,
  Optional[Variant[Array[String],String]]             $fallback_dns = undef,
  Optional[Variant[Array[String],String]]             $domains = undef,
  Optional[Variant[Boolean,Enum['resolve']]]          $llmnr = undef,
  Optional[Variant[Boolean,Enum['resolve']]]          $multicast_dns = undef,
  Optional[Variant[Boolean,Enum['allow-downgrade']]]  $dnssec = undef,
  Variant[Boolean,Enum['yes', 'opportunistic', 'no']] $dnsovertls = false,
  Variant[Boolean,Enum['no-negative']]                $cache = false,
  Optional[Variant[Boolean,Enum['udp','tcp']]]        $dns_stub_listener = undef,
  Boolean                                             $use_stub_resolver = false,
  Boolean                                             $manage_networkd = false,
  Enum['stopped','running']                           $networkd_ensure = 'running',
  Boolean                                             $manage_timesyncd = false,
  Enum['stopped','running']                           $timesyncd_ensure = 'running',
  Optional[Variant[Array,String]]                     $ntp_server = undef,
  Optional[Variant[Array,String]]                     $fallback_ntp_server = undef,
  Boolean                                             $manage_accounting = false,
  Boolean                                             $purge_dropin_dirs = true,
  Boolean                                             $manage_journald = true,
  Systemd::JournaldSettings                           $journald_settings = {},
  Boolean                                             $manage_udevd = false,
  Optional[Variant[Integer,String]]                   $udev_log = undef,
  Optional[Integer]                                   $udev_children_max = undef,
  Optional[Integer]                                   $udev_exec_delay = undef,
  Optional[Integer]                                   $udev_event_timeout = undef,
  Optional[Enum['early', 'late', 'never']]            $udev_resolve_names = undef,
  Optional[Variant[Integer,String]]                   $udev_timeout_signal = undef,
  Boolean                                             $manage_logind = false,
  Systemd::LogindSettings                             $logind_settings = {},
  Boolean                                             $manage_all_network_files = false,
  Stdlib::Absolutepath                                $network_path = '/etc/systemd/network',
  Hash                                                $loginctl_users = {},
  Hash                                                $dropin_files = {},
  Hash                                                $udev_rules = {},
) {
  create_resources('systemd::service_limits', $service_limits)

  if $manage_resolved and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-resolved.service'] {
    contain systemd::resolved
  }

  if $manage_networkd and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-networkd.service'] {
    contain systemd::networkd
  }

  if $manage_timesyncd and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-timesyncd.service'] {
    contain systemd::timesyncd
  }

  if $manage_udevd {
    contain systemd::udevd
  }

  if $manage_accounting {
    contain systemd::system
  }

  if $manage_journald {
    contain systemd::journald
  }

  if $manage_logind {
    contain systemd::logind
  }

  $dropin_files.each |$name, $resource| {
    systemd::dropin_file { $name:
      * => $resource,
    }
  }
}
