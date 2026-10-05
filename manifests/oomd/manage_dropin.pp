# Creates a drop-in file for oomd configuration from a template
#
# @api public
# @param filename The filename of the drop in. The full path is determined using the path and this filename.
# @param ensure the state of this dropin file
# @param comments An array of comments to put in the dropin
# @param path The oomd dropin configuration path
# @param selinux_ignore_defaults If Puppet should ignore the default SELinux labels.
# @param owner The owner to set on the dropin file
# @param group The group to set on the dropin file
# @param mode The mode to set on the dropin file
# @param show_diff Whether to show the diff when updating dropin file
# @param notify_oomd Restart the oomd service if the dropin file changes
# @param oomd_entry key value pairs for the [OOM] section of the dropin file
define systemd::oomd::manage_dropin (
  Systemd::OomdSettings          $oomd_entry,
  Systemd::Dropin                $filename                = $name,
  Enum['present', 'absent']      $ensure                  = 'present',
  Optional[Array[String]]        $comments                = undef,
  Optional[Stdlib::Absolutepath] $path                    = undef,
  Optional[Boolean]              $selinux_ignore_defaults = undef,
  Optional[String[1]]            $owner                   = undef,
  Optional[String[1]]            $group                   = undef,
  Optional[Stdlib::Filemode]     $mode                    = undef,
  Optional[Boolean]              $show_diff               = undef,
  Optional[Boolean]              $notify_oomd             = undef,
) {
  systemd::oomd::dropin_file { $name:
    ensure                  => $ensure,
    filename                => $filename,
    path                    => $path,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    owner                   => $owner,
    group                   => $group,
    mode                    => $mode,
    show_diff               => $show_diff,
    notify_oomd             => $notify_oomd,
    content                 => epp('systemd/config_dropin.epp', {
      'section'  => 'OOM',
      'settings' => $oomd_entry,
      'comments' => $comments,
    }),
  }
}
