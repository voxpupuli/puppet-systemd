# Creates a drop-in file for logind configuration
#
# @api public
#
# @see logind.conf(5)
# @param filename The filename of the drop in. The full path is determined using the path and this filename.
# @param ensure the state of this dropin file
# @param path The logind dropin configuration path
# @param selinux_ignore_defaults If Puppet should ignore the default SELinux labels.
# @param content The full content of the unit file (Mutually exclusive with `$source`)
# @param source The `File` resource compatible `source` (Mutually exclusive with `$content`)
# @param owner The owner to set on the dropin file
# @param group The group to set on the dropin file
# @param mode The mode to set on the dropin file
# @param show_diff Whether to show the diff when updating dropin file
# @param notify_logind Restart the logind service if the dropin file changes
define systemd::logind::dropin_file (
  Systemd::Dropin                             $filename                = $name,
  Enum['present', 'absent', 'file']           $ensure                  = 'present',
  Stdlib::Absolutepath                        $path                    = '/etc/systemd/logind.conf.d',
  Boolean                                     $selinux_ignore_defaults = false,
  Optional[Variant[String,Sensitive[String]]] $content                 = undef,
  Optional[String]                            $source                  = undef,
  String[1]                                   $owner                   = 'root',
  String[1]                                   $group                   = 'root',
  Stdlib::Filemode                            $mode                    = '0644',
  Boolean                                     $show_diff               = true,
  Boolean                                     $notify_logind           = true,
) {
  include systemd

  if $systemd::manage_logind == false {
    fail('systemd::logind::dropin_file is disabled because systemd::manage_logind is set to false')
  }

  $full_filename = "${path}/${filename}"

  if $ensure != 'absent' {
    ensure_resource('file', $path,
      {
        ensure                  => 'directory',
        owner                   => 'root',
        group                   => 'root',
        mode                    => '0755',
        recurse                 => $systemd::logind_purge_dropin_dirs,
        purge                   => $systemd::logind_purge_dropin_dirs,
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

  if $notify_logind {
    File[$full_filename] ~> Service['systemd-logind']
  }
}
