# This module allows triggering systemd commands once for all modules
#
# @api public
#
# @param default_target
#   The default systemd boot target, unmanaged if set to undef.
#
# @param service_limits
#   Deprecated, use dropin_files - Hash of `systemd::service_limits` resources
#
# @param networks
#   Hash of `systemd::network` resources
#
# @param timers
#   Hash of `systemd::timer` resources
#
# @param tmpfiles
#   Hash of `systemd::tmpfile` resources
#
# @param unit_files
#   Hash of `systemd::unit_file` resources
#
# @param manage_resolved
#   Manage the systemd resolver
#
# @param resolved_ensure
#   The state that the ``resolved`` service should be in. When migrating from 'running' to
#   'stopped' an attempt will be made to restore a working `/etc/resolv.conf` using
#   `/run/systemd/resolve/resolv.conf`.
#
# @param resolved_package
#   The name of a systemd sub package needed for systemd-resolved if one needs to be installed.
#
# @param manage_nspawn
#   Manage the systemd-nspawn@service and machinectl subsystem.
#
# @param nspawn_package
#   The name of a systemd sub package needed for the nspawn tools machinectl and
#   systemd-nspawn if one needs to be installed.
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
#   Takes a boolean argument or "no-negative". If left `undef` the cache setting will not be modified.
#
# @param dns_stub_listener
#   Takes a boolean argument or one of "udp" and "tcp".
#   Setting it to `'absent'` will remove `DNSStubListener` existing entries from the configuration file
#
# @param dns_stub_listener_extra
#   Additional addresses for the DNS stub listener to listen on
#   Setting it to `'absent'` will remove `DNSStubListenerExtra` existing entries from the configuration file
#
# @param manage_resolv_conf
#   For when `manage_resolved` is `true` should the file `/etc/resolv.conf` be managed.
#
# @param use_stub_resolver
#   Takes a boolean argument. When "false" (default) it uses /run/systemd/resolve/resolv.conf
#   as /etc/resolv.conf. When "true", it uses /run/systemd/resolve/stub-resolv.conf
#   When `resolved_ensure` is `stopped` this parameter is ignored.
#
# @param manage_networkd
#   Manage the systemd network daemon
#
# @param networkd_ensure
#   The state that the ``networkd`` service should be in
#
# @param networkd_package
#   Name of the package required for systemd-networkd, if any
#
# @param manage_timesyncd
#   Manage the systemd timesyncd daemon
#
# @param timesyncd_ensure
#   The state that the ``timesyncd`` service should be in
#
# @param timesyncd_package
#   Name of the package required for systemd-timesyncd, if any
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
# @param timezone
#   Set the system time zone to the specified value.
#   Available timezones can be listed with list-timezones.
#   If the RTC is configured to be in the local time, this will also update
#   the RTC time. This call will alter the /etc/localtime symlink.
#
# @param set_local_rtc
#   Takes a boolean argument. If "false", the system is configured to maintain
#   the RTC in universal time.
#   If "true", it will maintain the RTC in local time instead.
#   Note that maintaining the RTC in the local timezone is not fully supported
#   and will create various problems with time zone changes and daylight saving
#   adjustments. If at all possible, keep the RTC in UTC mode.
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
# @param machine_info_settings
#   Settings to place into /etc/machine-info (hostnamectl)
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
#   Configure dropin files via hiera and `systemd::dropin_file` with factory pattern
#
# @param manage_units
#   Configure units via hiera and `systemd::manage_unit` with factory pattern
#
# @param manage_dropins
#   Configure dropin files via hiera and `systemd::manage_dropin` with factory pattern
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
# @param manage_coredump
#   Should systemd-coredump configuration be managed
#
# @param coredump_settings
#   Hash of systemd-coredump configurations for coredump.conf
#
# @param coredump_backtrace
#   Add --backtrace to systemd-coredump call systemd-coredump@.service unit
#
# @param manage_oomd
#   Should systemd-oomd configuration be managed
#
# @param oomd_package
#   Name of the package required for systemd-oomd, if any
#
# @param oomd_ensure
#   The state that the ``oomd`` service should be in
#
# @param oomd_settings
#   Hash of systemd-oomd configurations for oomd.conf
#
# @param udev_purge_rules
#   Toggle if unmanaged files in /etc/udev/rules.d should be purged if manage_udevd is enabled
class systemd (
  Optional[Pattern['^.+\.target$']]                   $default_target = undef,
  Hash[String,String]                                 $accounting = {},
  Stdlib::CreateResources                             $service_limits = {},
  Stdlib::CreateResources                             $networks = {},
  Stdlib::CreateResources                             $timers = {},
  Stdlib::CreateResources                             $tmpfiles = {},
  Stdlib::CreateResources                             $unit_files = {},
  Boolean                                             $manage_resolved = false,
  Optional[Enum['systemd-resolved']]                  $resolved_package = undef,
  Enum['stopped','running']                           $resolved_ensure = 'running',
  Optional[Variant[Array[String],String]]             $dns = undef,
  Optional[Variant[Array[String],String]]             $fallback_dns = undef,
  Optional[Variant[Array[String],String]]             $domains = undef,
  Optional[Variant[Boolean,Enum['resolve']]]          $llmnr = undef,
  Optional[Variant[Boolean,Enum['resolve']]]          $multicast_dns = undef,
  Optional[Variant[Boolean,Enum['allow-downgrade']]]  $dnssec = undef,
  Variant[Boolean,Enum['yes', 'opportunistic', 'no']] $dnsovertls = false,
  Optional[Variant[Boolean,Enum['no-negative']]]      $cache = undef,
  Optional[Variant[Boolean,Enum['udp','tcp','absent']]]  $dns_stub_listener = undef,
  Optional[Variant[Array[String[1]],Enum['absent']]] $dns_stub_listener_extra = undef,
  Boolean                                             $manage_resolv_conf = true,
  Boolean                                             $use_stub_resolver = false,
  Boolean                                             $manage_networkd = false,
  Enum['stopped','running']                           $networkd_ensure = 'running',
  Optional[String[1]]                                 $networkd_package = undef,
  Boolean                                             $manage_timesyncd = false,
  Enum['stopped','running']                           $timesyncd_ensure = 'running',
  Optional[String[1]]                                 $timesyncd_package = undef,
  Optional[Variant[Array,String]]                     $ntp_server = undef,
  Optional[Variant[Array,String]]                     $fallback_ntp_server = undef,
  Optional[Boolean]                                   $set_local_rtc = undef,
  Optional[String[1]]                                 $timezone = undef,
  Boolean                                             $manage_accounting = false,
  Boolean                                             $purge_dropin_dirs = true,
  Boolean                                             $manage_journald = true,
  Systemd::JournaldSettings                           $journald_settings = {},
  Systemd::MachineInfoSettings                        $machine_info_settings = {},
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
  Stdlib::CreateResources                             $loginctl_users = {},
  Stdlib::CreateResources                             $dropin_files = {},
  Stdlib::CreateResources                             $manage_units = {},
  Stdlib::CreateResources                             $manage_dropins = {},
  Stdlib::CreateResources                             $udev_rules = {},
  Boolean                                             $manage_coredump = false,
  Boolean                                             $manage_nspawn = false,
  Optional[Enum['systemd-container']]                 $nspawn_package = undef,
  Systemd::CoredumpSettings                           $coredump_settings = {},
  Boolean                                             $coredump_backtrace = false,
  Boolean                                             $manage_oomd = false,
  Optional[String[1]]                                 $oomd_package = undef,
  Enum['stopped','running']                           $oomd_ensure = 'running',
  Systemd::OomdSettings                               $oomd_settings = {},
  Boolean                                             $udev_purge_rules = false,
) {
  contain systemd::install

  if $default_target {
    $target = shell_escape($default_target)
    service { $target:
      ensure => 'running',
      enable => true,
    }

    exec { "systemctl set-default ${target}":
      command => "systemctl set-default ${target}",
      unless  => "test $(systemctl get-default) = ${target}",
      path    => $facts['path'],
    }
  }

  $service_limits.each |$service_limit, $service_limit_data| {
    systemd::service_limits { $service_limit:
      * => $service_limit_data,
    }
  }
  $networks.each |$network, $network_data| {
    systemd::network { $network:
      * => $network_data,
    }
  }
  $timers.each |$timer, $timer_data| {
    systemd::timer { $timer:
      * => $timer_data,
    }
  }
  $tmpfiles.each |$tmpfile, $tmpfile_data| {
    systemd::tmpfile { $tmpfile:
      * => $tmpfile_data,
    }
  }
  $unit_files.each |$unit_file, $unit_file_data| {
    systemd::unit_file { $unit_file:
      * => $unit_file_data,
    }
  }

  if $manage_resolved and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-resolved.service'] {
    contain systemd::resolved
    Class['systemd::install'] -> Class['systemd::resolved']
  }

  if $manage_networkd and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-networkd.service'] {
    contain systemd::networkd
    Class['systemd::install'] -> Class['systemd::networkd']
  }

  contain systemd::timedatectl

  if $manage_timesyncd and $facts['systemd_internal_services'] and $facts['systemd_internal_services']['systemd-timesyncd.service'] {
    contain systemd::timesyncd
  }

  if $manage_udevd {
    contain systemd::udevd
  }

  if $manage_accounting {
    contain systemd::system
  }

  unless empty($machine_info_settings) {
    contain systemd::machine_info
  }

  if $manage_journald {
    contain systemd::journald
  }

  if $manage_logind {
    contain systemd::logind
  }

  if $manage_coredump {
    contain systemd::coredump
  }

  if $manage_oomd {
    contain systemd::oomd
  }

  $dropin_files.each |$name, $resource| {
    systemd::dropin_file { $name:
      * => $resource,
    }
  }

  $manage_units.each |$name, $resource| {
    systemd::manage_unit { $name:
      * => $resource,
    }
  }

  $manage_dropins.each |$name, $resource| {
    systemd::manage_dropin { $name:
      * => $resource,
    }
  }
}
