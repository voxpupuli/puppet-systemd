# Creates a drop-in file for user.conf configuration
#
# @api public
#
# @see systemd-user.conf(5)
# @param filename The filename of the drop in. The full path is determined using the path and this filename.
# @param ensure the state of this dropin file
# @param path The user.conf dropin configuration path
# @param selinux_ignore_defaults If Puppet should ignore the default SELinux labels.
# @param content The full content of the unit file (Mutually exclusive with `$source`)
# @param source The `File` resource compatible `source` (Mutually exclusive with `$content`)
# @param owner The owner to set on the dropin file
# @param group The group to set on the dropin file
# @param mode The mode to set on the dropin file
# @param show_diff Whether to show the diff when updating dropin file
# @param notify_user Trigger daemon-reexec if the dropin file changes
define systemd::user::dropin_file (
  Systemd::Dropin                             $filename                = $name,
  Enum['present', 'absent', 'file']           $ensure                  = 'present',
  Stdlib::Absolutepath                        $path                    = '/etc/systemd/user.conf.d',
  Boolean                                     $selinux_ignore_defaults = false,
  Optional[Variant[String,Sensitive[String]]] $content                 = undef,
  Optional[String]                            $source                  = undef,
  String[1]                                   $owner                   = 'root',
  String[1]                                   $group                   = 'root',
  Stdlib::Filemode                            $mode                    = '0644',
  Boolean                                     $show_diff               = true,
  Boolean                                     $notify_user             = true,
) {
  include systemd

  $full_filename = "${path}/${filename}"

  if $ensure != 'absent' {
    ensure_resource('file', $path,
      {
        ensure                  => 'directory',
        owner                   => 'root',
        group                   => 'root',
        mode                    => '0755',
        recurse                 => $systemd::user_purge_dropin_dirs,
        purge                   => $systemd::user_purge_dropin_dirs,
        selinux_ignore_defaults => $selinux_ignore_defaults,
      },
    )
  }

  file { $full_filename:
    ensure                  => stdlib::ensure($ensure, 'file'),
    content                 => $content,
    source                  => $source,
    owner                   => $owner,
    group                   => $group,
    mode                    => $mode,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    show_diff               => $show_diff,
  }

  if $notify_user {
    ensure_resource('systemd::daemon_reexec', 'user.conf')

    File[$full_filename] ~> Systemd::Daemon_reexec['user.conf']
  }
}
