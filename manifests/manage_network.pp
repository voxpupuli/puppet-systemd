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
# @param enable If set, manage the unit enablement status
# @param active If set, will manage the state of the unit
# @param restart Specify a restart command manually. If left unspecified, a standard Puppet service restart happens
# @param daemon_reload
#   call `systemd::daemon-reload` to ensure that the modified unit file is loaded
#
# @param match_entry key value pairs for [Match] section of the unit file
# @param network_entry key value pairs for [Network] section of the unit file
# @param link_entry key value pairs for [Link] section of the unit file
#
define systemd::manage_unit (
  Enum['present', 'absent']                $ensure                  = 'present',
  Stdlib::Absolutepath                     $path                    = '/etc/systemd/system',
  String                                   $owner                   = 'root',
  String                                   $group                   = 'root',
  Stdlib::Filemode                         $mode                    = '0444',
  Boolean                                  $show_diff               = true,
  Optional[Variant[Boolean, Enum['mask']]] $enable                  = undef,
  Optional[Boolean]                        $active                  = undef,
  Optional[String]                         $restart                 = undef,
  Boolean                                  $daemon_reload           = true,
  Optional[Systemd::Unit::Match]           $match_entry             = undef,
  Optional[Systemd::Unit::Network]         $network_entry           = undef,
  Optional[Systemd::Unit::Link]            $link_entry              = undef,
) {
  assert_type(Systemd::Network, $name)

  systemd::network { $name:
    ensure    => $ensure,
    path      => $path,
    owner     => $owner,
    group     => $group,
    mode      => $mode,
    show_diff => $show_diff,
    content   => epp('systemd/network.epp', {
        match_entry   => $match_entry,
        network_entry => $network_entry,
        link_entry    => $link_entry,
    }),
  }
}
