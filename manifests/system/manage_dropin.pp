# Creates a drop-in file for system.conf configuration from a template
#
# @api public
# @param filename The filename of the drop in. The full path is determined using the path and this filename.
# @param ensure the state of this dropin file
# @param comments An array of comments to put in the dropin
# @param path The system.conf dropin configuration path
# @param selinux_ignore_defaults If Puppet should ignore the default SELinux labels.
# @param owner The owner to set on the dropin file
# @param group The group to set on the dropin file
# @param mode The mode to set on the dropin file
# @param show_diff Whether to show the diff when updating dropin file
# @param notify_system Trigger daemon-reexec if the dropin file changes
# @param system_entry key value pairs for the [Manager] section of the dropin file
define systemd::system::manage_dropin (
  Systemd::ServiceManagerSettings $system_entry,
  Systemd::Dropin                 $filename                = $name,
  Enum['present', 'absent']       $ensure                  = 'present',
  Optional[Array[String]]         $comments                = undef,
  Optional[Stdlib::Absolutepath]  $path                    = undef,
  Optional[Boolean]               $selinux_ignore_defaults = undef,
  Optional[String[1]]             $owner                   = undef,
  Optional[String[1]]             $group                   = undef,
  Optional[Stdlib::Filemode]      $mode                    = undef,
  Optional[Boolean]               $show_diff               = undef,
  Optional[Boolean]               $notify_system           = undef,
) {
  systemd::system::dropin_file { $name:
    ensure                  => $ensure,
    filename                => $filename,
    path                    => $path,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    owner                   => $owner,
    group                   => $group,
    mode                    => $mode,
    show_diff               => $show_diff,
    notify_system           => $notify_system,
    content                 => epp('systemd/config_dropin.epp', {
      'section'  => 'Manager',
      'settings' => $system_entry,
      'comments' => $comments,
    }),
  }
}
