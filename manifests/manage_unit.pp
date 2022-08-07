# @summary Generate unit file from template
#
# @api public
#
# @see systemd.unit(5)
#
# @example Generate a service
#   systemd::manage_unit{ 'myrunner.service':
#     $unit_entry    => {
#       'Description' => 'My great service',
#     },
#     $service_entry => {
#       'Type'       => 'oneshot',
#       'ExecStart' => '/usr/bin/doit.sh',
#     },
#     $install_entry => {
#       WantedBy => 'multi-user.target',
#     },
#   }
# @param name [Pattern['^[^/]+\.(service|socket|device|mount|automount|swap|target|path|timer|slice|scope)$']]
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
# @param selinux_ignore_defaults
#   maps to the same param on the file resource for the unit. false in the module because it's false in the file resource type
# @param service_parameters
#   hash that will be passed with the splat operator to the service resource
# @param daemon_reload
#   call `systemd::daemon-reload` to ensure that the modified unit file is loaded
#
# @param unit_entry  key value pairs for [Unit] section of the unit file.
# @param service_entry key value pairs for [Service] section of the unit file.
# @param install_entry key value pairs for [Install] section of the unit file.
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
  Boolean                                  $selinux_ignore_defaults = false,
  Hash[String[1], Any]                     $service_parameters      = {},
  Boolean                                  $daemon_reload           = true,
  Optional[Systemd::Unit::Install]         $install_entry           = undef,
  Systemd::Unit::Unit                      $unit_entry,
  Systemd::Unit::Service                   $service_entry,
) {
  assert_type(Systemd::Unit, $name)

  systemd::unit_file { $name:
    ensure                  => $ensure,
    path                    => $path,
    owner                   => $owner,
    group                   => $group,
    mode                    => $mode,
    show_diff               => $show_diff,
    enable                  => $enable,
    active                  => $active,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    service_parameters      => $service_parameters,
    daemon_reload           => $daemon_reload,
    content                 => epp('systemd/unit_file.epp', {
        'unit_entry'    => $unit_entry,
        'service_entry' => $service_entry,
        'install_entry' => $install_entry,
    }),
  }
}
