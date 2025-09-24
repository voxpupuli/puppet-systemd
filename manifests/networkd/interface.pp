# @summary This class implements a network interface file for systemd-networkd
#
# This class implements a network interface file for systemd-networkd. The advantage
# of this class over `systemd::network` is that it utilizes all the types
# provided by this module to validate input instead of just writing a file
# with the given content.
#
# @param type
#   Parameter is deprecated in favor of the structured $interface parameter
#   The type of networkd interface to create
#
# @param interface
#   An interface to configure on a node.
#   The link, netdev and network parameters are deep merged with the respective profile
#   With the profiles you can set the default values for a network.
#   Hint: to remove a profile setting for an interface you can either overwrite or
#   set it to `~` for removal.
#
# @param path
#   path where all networkd files are placed in
#
# @param link_profile
#   Hash of a network link profile
#   The structure is equal to the 'link' parameter of an interface.
#
# @param netdev_profile
#   Hash of a netdev profile
#   The structure is equal to the 'netdev' parameter of an interface.
#
# @param network_profile
#   Hash of a network profile
#   The structure is equal to the 'network' parameter of an interface.
#
# @example
#   $_network_profile = {
#     'Network' => {
#       'Gateway' => '192.168.0.1',
#     },
#   }
#
#   $_interface => {
#     'filename' => '50-static',
#     'network' => {
#       'Match' => {
#         'Name' => 'enp2s0',
#       },
#       'Network' => {
#         'Address' => '192.168.0.15/24',
#       },
#     },
#   }
#
#   systemd::networkd::interface { 'static-enp2s0':
#     interface       => $_interface,
#     network_profile => $_network_profile,
#   }
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
# @example
#   $_interface => {
#     'filename' => '40-dummy',
#     'netdev' => {
#       'NetDev' => {
#         'Name' => 'dummy0',
#         'Kind' => 'dummy',
#       },
#     'network' => {
#       'Match' => {
#         'Name' => 'dummy0',
#       },
#       'Network' => {
#         'Address' => '2001:DB8::42:42/64
#       },
#     },
#   }
#   systemd::networkd::interface { 'static-dummy':
#     interface       => $_interface,
#   }
#
#   Creates a dummy interface, on the file system, two files
#   are created therefore.
#
define systemd::networkd::interface (
  Systemd::Interface $interface,
  Stdlib::Absolutepath $path = '/etc/systemd/network',
  Systemd::Interface::Link $link_profile = {},
  Systemd::Interface::Netdev $netdev_profile = {},
  Systemd::Interface::Network $network_profile = {},
  # deprectated
  Optional[Enum['link', 'netdev', 'network']] $type = undef,
) {
  $_filename=pick($interface['filename'], $title)

  # deprecation of type parameter:
  if $type {
    deprecation('systemd::networkd::interface::type', "This parameter is deprecated since it contains duplicated information. It's save to remove it.")
  }

  if 'link' in $interface.keys() {
    systemd::network { "${_filename}.link":
      path    => $path,
      content => epp('systemd/network.epp',
        {
          fname  => "${_filename}.link",
          config => deep_merge($link_profile, $interface['link']),
        },
      ),
    }
  }
  if 'netdev' in $interface.keys() {
    systemd::network { "${_filename}.netdev":
      path    => $path,
      content => epp('systemd/network.epp',
        {
          fname  => "${_filename}.netdev",
          config => deep_merge($netdev_profile, $interface['netdev']),
        },
      ),
    }
  }
  if 'network' in $interface.keys() {
    systemd::network { "${_filename}.network":
      path    => $path,
      content => epp('systemd/network.epp',
        {
          fname  => "${_filename}.network",
          config => deep_merge($network_profile, $interface['network']),
        },
      ),
    }
  }
}
