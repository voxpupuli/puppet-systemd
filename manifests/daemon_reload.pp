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
define systemd::daemon_reload (
  Boolean $enable = true,
) {
  if $enable {
    exec { "${module_name}-${name}-systemctl-daemon-reload":
      command     => 'systemctl daemon-reload',
      refreshonly => true,
      path        => $facts['path'],
    }
  }
}
