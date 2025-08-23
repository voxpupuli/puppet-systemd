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
