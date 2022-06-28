# Creates a drop-in file for a systemd unit from a template
#
# @api public
#
# @see systemd.unit(5)
#
# @example drop in file to change Type and override ExecStart
#   systemd::manage_dropin { 'myconf.conf':
#     ensure        => present,
#     unit          => 'myservice.service',
#     service_entry => {
#       'Type'      => 'oneshot',
#       'ExecStart' => ['', '/usr/bin/doit.sh'],
#     },
#   }
#
# @param unit The unit to create a dropfile for
# @param filename The target unit file to create. The filename of the drop in. The full path is determined using the path, unit and this filename.
# @param ensure The state of this dropin file
# @param path The main systemd configuration path
# @param selinux_ignore_defaults If Puppet should ignore the default SELinux labels
# @param owner The owner to set on the dropin file
# @param group The group to set on the dropin file
# @param mode The mode to set on the dropin file
# @param show_diff Whether to show the diff when updating dropin file
# @param notify_service Notify a service for the unit, if it exists
# @param daemon_reload Call systemd::daemon_reload
# @param unit_entry key value pairs for [Unit] section of the unit file
# @param service_entry key value pairs for [Service] section of the unit file
# @param install_entry key value pairs for [Install] section of the unit file
#
define systemd::manage_dropin (
  Systemd::Unit                    $unit,
  Systemd::Dropin                  $filename                = $name,
  Enum['present', 'absent']        $ensure                  = 'present',
  Stdlib::Absolutepath             $path                    = '/etc/systemd/system',
  Boolean                          $selinux_ignore_defaults = false,
  String                           $owner                   = 'root',
  String                           $group                   = 'root',
  Stdlib::Filemode                 $mode                    = '0444',
  Boolean                          $show_diff               = true,
  Boolean                          $notify_service          = false,
  Boolean                          $daemon_reload           = true,
  Optional[Systemd::Unit::Install] $install_entry           = undef,
  Optional[Systemd::Unit::Unit]    $unit_entry              = undef,
  Optional[Systemd::Unit::Service] $service_entry           = undef,
) {
  systemd::dropin_file { $name:
    ensure                  => $ensure,
    filename                => $filename,
    unit                    => $unit,
    path                    => $path,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    owner                   => $owner,
    group                   => $group,
    mode                    => $mode,
    show_diff               => $show_diff,
    notify_service          => $notify_service,
    daemon_reload           => $daemon_reload,
    content                 => epp('systemd/unit_file.epp', {
        'unit_entry'    => $unit_entry,
        'service_entry' => $service_entry,
        'install_entry' => $install_entry,
    }),
  }
}
