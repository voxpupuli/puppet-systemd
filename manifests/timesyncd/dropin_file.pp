# Creates a drop-in file for timesyncd configuration
#
# @api public
#
# @see timesyncd.conf(5)
# @param filename The filename of the drop in. The full path is determined using the path and this filename.
# @param ensure the state of this dropin file
# @param path The timesyncd dropin configuration path
# @param selinux_ignore_defaults If Puppet should ignore the default SELinux labels.
# @param content The full content of the unit file (Mutually exclusive with `$source`)
# @param source The `File` resource compatible `source` (Mutually exclusive with `$content`)
# @param owner The owner to set on the dropin file
# @param group The group to set on the dropin file
# @param mode The mode to set on the dropin file
# @param show_diff Whether to show the diff when updating dropin file
# @param notify_timesyncd Restart the timesyncd service if the dropin file changes
define systemd::timesyncd::dropin_file (
  Systemd::Dropin                             $filename                = $name,
  Enum['present', 'absent', 'file']           $ensure                  = 'present',
  Stdlib::Absolutepath                        $path                    = '/etc/systemd/timesyncd.conf.d',
  Boolean                                     $selinux_ignore_defaults = false,
  Optional[Variant[String,Sensitive[String]]] $content                 = undef,
  Optional[String]                            $source                  = undef,
  String[1]                                   $owner                   = 'root',
  String[1]                                   $group                   = 'root',
  Stdlib::Filemode                            $mode                    = '0644',
  Boolean                                     $show_diff               = true,
  Boolean                                     $notify_timesyncd        = true,
) {
  include systemd

  if $systemd::manage_timesyncd == false {
    fail('systemd::timesyncd::dropin_file is disabled because systemd::manage_timesyncd is set to false')
  }

  $full_filename = "${path}/${filename}"

  if $ensure != 'absent' {
    ensure_resource('file', $path,
      {
        ensure                  => 'directory',
        owner                   => 'root',
        group                   => 'root',
        mode                    => '0755',
        recurse                 => $systemd::timesyncd_purge_dropin_dirs,
        purge                   => $systemd::timesyncd_purge_dropin_dirs,
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

  if $notify_timesyncd {
    File[$full_filename] ~> Service['systemd-timesyncd']
  }
}
