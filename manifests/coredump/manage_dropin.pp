# Creates a drop-in file for coredump configuration from a template
#
# @api public
# @param filename The filename of the drop in. The full path is determined using the path and this filename.
# @param ensure the state of this dropin file
# @param comments An array of comments to put in the dropin
# @param path The coredump dropin configuration path
# @param selinux_ignore_defaults If Puppet should ignore the default SELinux labels.
# @param owner The owner to set on the dropin file
# @param group The group to set on the dropin file
# @param mode The mode to set on the dropin file
# @param show_diff Whether to show the diff when updating dropin file
# @param notify_coredump
#   Accepted for API consistency but unused and has no effect.
#   See systemd::coredump::dropin_file for details on why coredump config
#   does not require service restart or daemon-reload.
# @param coredump_entry key value pairs for the [Coredump] section of the dropin file
define systemd::coredump::manage_dropin (
  Systemd::CoredumpSettings      $coredump_entry,
  Systemd::Dropin                $filename                = $name,
  Enum['present', 'absent']      $ensure                  = 'present',
  Optional[Array[String]]        $comments                = undef,
  Optional[Stdlib::Absolutepath] $path                    = undef,
  Optional[Boolean]              $selinux_ignore_defaults = undef,
  Optional[String[1]]            $owner                   = undef,
  Optional[String[1]]            $group                   = undef,
  Optional[Stdlib::Filemode]     $mode                    = undef,
  Optional[Boolean]              $show_diff               = undef,
  Optional[Boolean]              $notify_coredump         = undef,
) {
  systemd::coredump::dropin_file { $name:
    ensure                  => $ensure,
    filename                => $filename,
    path                    => $path,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    owner                   => $owner,
    group                   => $group,
    mode                    => $mode,
    show_diff               => $show_diff,
    notify_coredump         => $notify_coredump,
    content                 => epp('systemd/config_dropin.epp', {
      'section'  => 'Coredump',
      'settings' => $coredump_entry,
      'comments' => $comments,
    }),
  }
}
