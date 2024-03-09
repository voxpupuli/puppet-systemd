# @api private
#
# @summary This class provides an abstract way to trigger resolved.
# Each parameters correspond to resolved.conf(5)
# @see https://www.freedesktop.org/software/systemd/man/resolved.conf.html
#
# @param ensure
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
# @param dns_stub_listener_extra
#   Additional addresses for the DNS stub listener to listen on
#
# @param use_stub_resolver
#   Takes a boolean argument. When "false" (default) it uses /run/systemd/resolve/resolv.conf
#   as /etc/resolv.conf. When "true", it uses /run/systemd/resolve/stub-resolv.conf
#
class systemd::resolved (
  Enum['stopped','running'] $ensure                                  = $systemd::resolved_ensure,
  Optional[Variant[Array[String],String]] $dns                       = $systemd::dns,
  Optional[Variant[Array[String],String]] $fallback_dns              = $systemd::fallback_dns,
  Optional[Variant[Array[String],String]] $domains                   = $systemd::domains,
  Optional[Variant[Boolean,Enum['resolve']]] $llmnr                  = $systemd::llmnr,
  Optional[Variant[Boolean,Enum['resolve']]] $multicast_dns          = $systemd::multicast_dns,
  Optional[Variant[Boolean,Enum['allow-downgrade']]] $dnssec         = $systemd::dnssec,
  Optional[Variant[Boolean,Enum['yes', 'opportunistic', 'no']]] $dnsovertls = $systemd::dnsovertls,
  Optional[Variant[Boolean,Enum['no-negative']]] $cache               = $systemd::cache,
  Optional[Variant[Boolean,Enum['udp', 'tcp','absent']]] $dns_stub_listener = $systemd::dns_stub_listener,
  Optional[Variant[Array[String[1]],Enum['absent']]] $dns_stub_listener_extra = $systemd::dns_stub_listener_extra,
  Boolean $use_stub_resolver                                         = $systemd::use_stub_resolver,
) {
  assert_private()

  $_enable_resolved = $ensure ? {
    'stopped' => false,
    'running' => true,
    default   => $ensure,
  }

  service { 'systemd-resolved':
    ensure => $ensure,
    enable => $_enable_resolved,
  }

  if $systemd::manage_resolv_conf {
    if $ensure == 'running' {
      $_resolv_conf_target = $use_stub_resolver ? {
        true    => '/run/systemd/resolve/stub-resolv.conf',
        default => '/run/systemd/resolve/resolv.conf',
      }
      file { '/etc/resolv.conf':
        ensure  => 'symlink',
        target  => $_resolv_conf_target,
        require => Service['systemd-resolved'],
      }
    } else {
      # If systemd not running make a last ditch attempt to restore
      # /etc/resolv.conf to something that might actually work on
      # reboot.
      exec { 'restore_resolv.conf_if_possible':
        command  => 'cp --remove-destination -f /run/systemd/resolve/resolv.conf /etc/resolv.conf',
        onlyif   => 'l="$(readlink /etc/resolv.conf)"; test "$l" = "/run/systemd/resolve/resolv.conf" || test "$l" = "/run/systemd/resolve/stub-resolv.conf',
        path     => $facts['path'],
        provider => 'shell',
      }
    }
  }

  if $dns {
    if $dns =~ String {
      $_dns = $dns
    } else {
      $_dns = join($dns, ' ')
    }
    ini_setting { 'dns':
      ensure  => 'present',
      value   => $_dns,
      setting => 'DNS',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  if $fallback_dns {
    if $fallback_dns =~ String {
      $_fallback_dns = $fallback_dns
    } else {
      $_fallback_dns = join($fallback_dns, ' ')
    }
    ini_setting { 'fallback_dns':
      ensure  => 'present',
      value   => $_fallback_dns,
      setting => 'FallbackDNS',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  if $domains {
    if $domains =~ String {
      $_domains = $domains
    } else {
      $_domains = join($domains, ' ')
    }
    ini_setting { 'domains':
      ensure  => 'present',
      value   => $_domains,
      setting => 'Domains',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  $_llmnr = $llmnr ? {
    true    => 'yes',
    false   => 'no',
    default => $llmnr,
  }

  if $_llmnr {
    ini_setting { 'llmnr':
      ensure  => 'present',
      value   => $_llmnr,
      setting => 'LLMNR',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  $_multicast_dns = $multicast_dns ? {
    true    => 'yes',
    false   => 'no',
    default => $multicast_dns,
  }

  if $_multicast_dns {
    ini_setting { 'multicast_dns':
      ensure  => 'present',
      value   => $_multicast_dns,
      setting => 'MulticastDNS',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  $_dnssec = $dnssec ? {
    true    => 'yes',
    false   => 'no',
    default => $dnssec,
  }

  if $_dnssec {
    ini_setting { 'dnssec':
      ensure  => 'present',
      value   => $_dnssec,
      setting => 'DNSSEC',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  $_dnsovertls = $dnsovertls ? {
    'yes'   => true,
    true    => 'opportunistic',
    false   => false,
    default => $dnsovertls,
  }

  if $_dnsovertls {
    ini_setting { 'dnsovertls':
      ensure  => 'present',
      value   => $_dnsovertls,
      setting => 'DNSOverTLS',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  $_cache = $cache ? {
    true    => 'yes',
    false   => 'no',
    default => $cache,
  }

  if $_cache {
    ini_setting { 'cache':
      ensure  => 'present',
      value   => $_cache,
      setting => 'Cache',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  $_dns_stub_listener = $dns_stub_listener ? {
    true    => 'yes',
    false   => 'no',
    default => $dns_stub_listener,
  }

  if  $dns_stub_listener =~ String[1] {
    ini_setting { 'dns_stub_listener':
      ensure  => stdlib::ensure($dns_stub_listener != 'absent'),
      value   => $_dns_stub_listener,
      setting => 'DNSStubListener',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }

  if $dns_stub_listener_extra =~ NotUndef {
    ini_setting { 'dns_stub_listener_extra':
      ensure  => stdlib::ensure($dns_stub_listener_extra != 'absent'),
      value   => $dns_stub_listener_extra,
      setting => 'DNSStubListenerExtra',
      section => 'Resolve',
      path    => '/etc/systemd/resolved.conf',
      notify  => Service['systemd-resolved'],
    }
  }
}
