# @api private
#
# @summary This class provides an abstract way to trigger systemd-networkd
#
# @param ensure The state that the ``networkd`` service should be in
# @param path path where all networkd files are placed in
# @param manage_all_network_files if enabled, all networkd files that aren't managed by puppet will be purged
# @param link_profiles
#   Hash of network link profiles that can be referenced by its key on an interface
#   The structure is equal to the 'link' parameter of an interface.
# @param netdev_profiles
#   Hash of netdev profiles that can be referenced by its key on an interface
#   The structure is equal to the 'netdev' parameter of an interface.
# @param network_profiles
#   Hash of network profiles that can be referenced by its key on an interface
#   The structure is equal to the 'network' parameter of an interface.
# @param interfaces
#  Hash of interfaces to configure on a node.
#  The link, netdev, and network parameters are deep merged with the respective profile
#  (referenced by the key of the interface).
#  With the profiles you can set the default values for a network.
#  Hint: to remove a profile setting for an interface you can either overwrite or
#  set it to `~` for removal.
#  Example (hiera yaml notation):
#    systemd::networkd::network_profiles:
#      mynet:
#        Network:
#          Gateway: 192.168.0.1
#
#    systemd::networkd::interfaces:
#      mynet:
#        filename: 50-static
#        network:
#          Match:
#            Name: enp2s0
#          Network:
#            Address: 192.168.0.15/24
#
#   Gives you a file /etc/systemd/network/50-static.network
#   with content:
#     [Network]
#     Gateway=192.168.0.1
#     Address=192.168.0.15/24
#
#     [Match]
#     Name=enp2s0
#
class systemd::networkd (
  Enum['stopped','running'] $ensure = $systemd::networkd_ensure,
  Stdlib::Absolutepath $path = $systemd::network_path,
  Boolean $manage_all_network_files = $systemd::manage_all_network_files,
  Hash[String[1],Systemd::Interface::Link] $link_profiles = {},
  Hash[String[1],Systemd::Interface::Netdev] $netdev_profiles = {},
  Hash[String[1],Systemd::Interface::Network] $network_profiles = {},
  Hash[String[1],Systemd::Interface] $interfaces = {},
) {
  assert_private()

  $_enable_networkd = $ensure ? {
    'stopped' => false,
    'running' => true,
    default   => $ensure,
  }

  service { 'systemd-networkd':
    ensure => $ensure,
    enable => $_enable_networkd,
  }

  $common_ini_setting_attributes = {
    path   => '/etc/systemd/networkd.conf',
    notify => Service['systemd-networkd'],
  }

  if $systemd::speed_meter {
    ini_setting { 'speed_meter':
      section => 'Network',
      setting => 'SpeedMeter',
      value   => $systemd::speed_meter,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::speed_meter_interval {
    ini_setting { 'speed_meter_interval':
      section => 'Network',
      setting => 'SpeedMeterIntervalSec',
      value   => $systemd::speed_meter_interval,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::manage_foreign_routing_policy_rules {
    ini_setting { 'manage_foreign_routing_policy_rules':
      section => 'Network',
      setting => 'ManageForeignRoutingPolicyRules',
      value   => $systemd::manage_foreign_routing_policy_rules,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::manage_foreign_routes {
    ini_setting { 'manage_foreign_routes':
      section => 'Network',
      setting => 'ManageForeignRoutes',
      value   => $systemd::manage_foreign_routes,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::manage_foreign_next_hops {
    ini_setting { 'manage_foreign_next_hops':
      section => 'Network',
      setting => 'ManageForeignNextHops',
      value   => $systemd::manage_foreign_next_hops,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::route_table {
    ini_setting { 'route_table':
      section => 'Network',
      setting => 'RouteTable',
      value   => $systemd::route_table,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::ipv4_forwarding {
    ini_setting { 'ipv4_forwarding':
      section => 'Network',
      setting => 'IPv4Forwarding',
      value   => $systemd::ipv4_forwarding,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::ipv6_forwarding {
    ini_setting { 'ipv6_forwarding':
      section => 'Network',
      setting => 'IPv6Forwarding',
      value   => $systemd::ipv6_forwarding,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::ipv6_privacy_extensions {
    ini_setting { 'ipv6_privacy_extensions':
      section => 'Network',
      setting => 'IPv6PrivacyExtensions',
      value   => $systemd::ipv6_privacy_extensions,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::use_domains {
    ini_setting { 'use_domains':
      section => 'Network',
      setting => 'UseDomains',
      value   => $systemd::use_domains,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::ipv6_accept_ra_use_domains {
    ini_setting { 'ipv6_accept_ra_use_domains':
      section => 'IPv6AcceptRA',
      setting => 'UseDomains',
      value   => $systemd::ipv6_accept_ra_use_domains,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::dhcpv4_client_identifier {
    ini_setting { 'dhcpv4_client_identifier':
      section => 'DHCPv4',
      setting => 'ClientIdentifier',
      value   => $systemd::dhcpv4_client_identifier,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::dhcpv4_duid_type {
    ini_setting { 'dhcpv4_duid_type':
      section => 'DHCPv4',
      setting => 'DUIDType',
      value   => $systemd::dhcpv4_duid_type,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::dhcpv4_duid_raw_data {
    ini_setting { 'dhcpv4_duid_raw_data':
      section => 'DHCPv4',
      setting => 'DUIDRawData',
      value   => $systemd::dhcpv4_duid_raw_data,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::dhcpv4_use_domains {
    ini_setting { 'dhcpv4_use_domains':
      section => 'DHCPv4',
      setting => 'UseDomains',
      value   => $systemd::dhcpv4_use_domains,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::dhcpv6_duid_type {
    ini_setting { 'dhcpv6_duid_type':
      section => 'DHCPv6',
      setting => 'DUIDType',
      value   => $systemd::dhcpv6_duid_type,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::dhcpv6_duid_raw_data {
    ini_setting { 'dhcpv6_duid_raw_data':
      section => 'DHCPv6',
      setting => 'DUIDRawData',
      value   => $systemd::dhcpv6_duid_raw_data,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::dhcpv6_use_domains {
    ini_setting { 'dhcpv6_use_domains':
      section => 'DHCPv6',
      setting => 'UseDomains',
      value   => $systemd::dhcpv6_use_domains,
      *       => $common_ini_setting_attributes,
    }
  }

  if $systemd::dhcp_server_persist_leases {
    ini_setting { 'dhcp_server_persist_leases':
      section => 'DHCPServer',
      setting => 'PersistLeases',
      value   => $systemd::dhcp_server_persist_leases,
      *       => $common_ini_setting_attributes,
    }
  }

  # this directory is created by systemd
  # we define it here to purge non-managed files
  if $manage_all_network_files {
    file { $path:
      ensure  => 'directory',
      recurse => true,
      purge   => true,
      notify  => Service['systemd-networkd'],
    }
  }

  $interfaces.each | String[1] $interface_name, Systemd::Interface $interface | {
    $_filename=pick($interface['filename'], $interface_name)
    systemd::networkd::interface { $_filename:
      path            => $path,
      interface       => $interface,
      link_profile    => pick($link_profiles[$interface_name], {}),
      netdev_profile  => pick($netdev_profiles[$interface_name], {}),
      network_profile => pick($network_profiles[$interface_name], {}),
    }
  }
}
