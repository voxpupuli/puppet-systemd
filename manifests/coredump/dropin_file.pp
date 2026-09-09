# Creates a drop-in file for coredump configuration
#
# @api public
#
# @see coredump.conf(5)
# @param filename The filename of the drop in. The full path is determined using the path and this filename.
# @param ensure the state of this dropin file
# @param path The coredump dropin configuration path
# @param selinux_ignore_defaults If Puppet should ignore the default SELinux labels.
# @param content The full content of the unit file (Mutually exclusive with `$source`)
# @param source The `File` resource compatible `source` (Mutually exclusive with `$content`)
# @param owner The owner to set on the dropin file
# @param group The group to set on the dropin file
# @param mode The mode to set on the dropin file
# @param show_diff Whether to show the diff when updating dropin file
# @param notify_coredump
#   Accepted for API consistency with other systemd::*::dropin_file defines, but
#   unused and has no effect. Coredump configuration is read on-demand by
#   systemd-coredump when processing core dumps, not at daemon startup. Therefore,
#   changes to coredump.conf or coredump.conf.d files take effect automatically
#   on the next core dump event without requiring a service restart or daemon-reload.
#
#   @see https://www.freedesktop.org/software/systemd/man/systemd-coredump.html
#   @see https://www.freedesktop.org/software/systemd/man/coredump.conf.html
define systemd::coredump::dropin_file (
  Systemd::Dropin                             $filename                = $name,
  Enum['present', 'absent', 'file']           $ensure                  = 'present',
  Stdlib::Absolutepath                        $path                    = '/etc/systemd/coredump.conf.d',
  Boolean                                     $selinux_ignore_defaults = false,
  Optional[Variant[String,Sensitive[String]]] $content                 = undef,
  Optional[String]                            $source                  = undef,
  String[1]                                   $owner                   = 'root',
  String[1]                                   $group                   = 'root',
  Stdlib::Filemode                            $mode                    = '0644',
  Boolean                                     $show_diff               = true,
  Optional[Boolean]                           $notify_coredump         = undef,
) {
  include systemd

  if $systemd::manage_coredump == false {
    fail('systemd::coredump::dropin_file is disabled because systemd::manage_coredump is set to false')
  }

  # Coredump configuration is read on-demand, so no service notify trigger is needed.
  # The $notify_coredump parameter exists for API consistency only and is intentionally unused.

  $full_filename = "${path}/${filename}"

  if $ensure != 'absent' {
    ensure_resource('file', $path,
      {
        ensure                  => 'directory',
        owner                   => 'root',
        group                   => 'root',
        mode                    => '0755',
        recurse                 => $systemd::coredump_purge_dropin_dirs,
        purge                   => $systemd::coredump_purge_dropin_dirs,
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
    # NOTE: No notify trigger - coredump config is read on-demand
  }
}
