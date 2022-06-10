# @summary Run systemctl daemon-reload
#
# @api public
#
# @param name
#   A globally unique name for the resource
#
# @param enable
#   Enable the reload exec
#
#   * Added in case users want to disable the reload globally using a resource collector
#
# @param lazy_reload
#   Enable a global lazy reload.
#
#   * This is meant for cleaning up systems that may have gotten out of sync so no particular
#     care is taken in trying to actually "fix" things, that would require a custom type that
#     manipulates the running catalog tree.
#
define systemd::daemon_reload (
  Boolean $enable      = true,
  Boolean $lazy_reload = false,
) {
  if $enable {
    if $lazy_reload {
      exec { "${module_name}-${name}-global-systemctl-daemon-check":
        command => 'systemctl daemon-reload',
        onlyif  => 'systemctl show "*" --property=NeedDaemonReload | grep -q "=yes"',
        path    => $facts['path'],
      }

      # Give services a fighting chance of coming up properly
      Exec["${module_name}-${name}-global-systemctl-daemon-check"] -> Service <||>
    }

    exec { "${module_name}-${name}-systemctl-daemon-reload":
      command     => 'systemctl daemon-reload',
      refreshonly => true,
      path        => $facts['path'],
    }
  }
}
