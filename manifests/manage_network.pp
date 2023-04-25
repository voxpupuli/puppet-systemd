# @summary Generate network file from template
#
# @api public
#
# @see systemd.network(5)
#
# @example network file
#   systemd::manage_network { 'eth0':
#     ensure        => present,
#     match_entry   => 'eth0',
#     network_entry => {
#       address => '1.2.3.4',
#       gateway => '7.8.9.0',
#       dns     => '1.1.1.1'
#     }
#   }
#
# @param name [Pattern['^[^/]+\.(network|netdev|link)$']]
#   The target unit file to create
#
# @param ensure The state of the unit file to ensure
# @param path The main systemd configuration path
# @param owner The owner to set on the unit file
# @param group The group to set on the unit file
# @param mode The mode to set on the unit file
# @param show_diff Whether to show the diff when updating unit file
# @param restart_service if netword should be restarted.
# @param match_entry key value pairs for [Match] section of the unit file
# @param network_entry key value pairs for [Network] section of the unit file
# @param address_entry key value pairs for [Address] section of the unit file
#
define systemd::manage_network (
  Enum['file', 'absent']                   $ensure                  = 'file',
  Stdlib::Absolutepath                     $path                    = '/etc/systemd/system',
  String                                   $owner                   = 'root',
  String                                   $group                   = 'root',
  Stdlib::Filemode                         $mode                    = '0444',
  Boolean                                  $show_diff               = true,
  Boolean                                  $restart_service           = true,
  Optional[Hash]                           $match_entry             = undef,
  Optional[Hash]                           $network_entry           = undef,
  Optional[Hash]                           $address_entry           = undef,
) {
  assert_type(Systemd::Network, $name)

  systemd::network { $name:
    ensure          => $ensure,
    path            => $path,
    owner           => $owner,
    group           => $group,
    mode            => $mode,
    show_diff       => $show_diff,
    restart_service => $restart_service,
    content         => epp('systemd/network.epp', {
        match_entry   => $match_entry,
        network_entry => $network_entry,
        address_entry => $address_entry,
    }),
  }
}
