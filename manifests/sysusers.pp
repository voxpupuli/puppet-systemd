# @summary  Prepare systemd sysusers files
#
# @api public
#
# @param purgedir If true /etc/sysusers.d will be purged of unmanaged files.
#
# @see systemd-sysusers(8)
#
class systemd::sysusers (
  Boolean $purgedir = true,
) {
  file { '/etc/sysusers.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    purge   => $purgedir,
    recurse => $purgedir,
    force   => $purgedir,
  }

  exec { 'systemd-sysusers':
    command     => 'systemd-sysusers',
    refreshonly => true,
    path        => $facts['path'],
  }
}
