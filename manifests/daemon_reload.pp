# @summary Run systemctl daemon-reload
#
# @api public
#
# @param name
#   A globally unique name for the resource
#
# @param enable
#   Enable the reload exec
#   * Added in case users want to disable the reload globally using a resource collector
#
# @param uid
#   Specify uid of `systemd --user` to reload. When `uid` is left `undef` the system
#   systemd instance will be reloaded. It is assumed that the `XDG_RUNTIME_DIR` for
#   the user is `/run/user/<uid>`.
#
# @example Force reload the system systemd
#   notify{ 'fake event to notify from':
#     notify => Systemd::Daemon_reload['special']
#   }
#   systemd::daemon_reload{ 'special': }
#
# @example Force reload a systemd --user
#   notify{ 'fake event to notify from':
#     notify => Systemd::Daemon_reload['user']
#   }
#   systemd::daemon_reload{ 'user':
#     uid => 1234,
#   }
#
define systemd::daemon_reload (
  Boolean $enable = true,
  Optional[Integer[1]] $uid = undef,
) {
  if $enable {
    # For a `systemd --user` instance XDG_RUNTIME_DIR must be set so dbus
    # can be found.

    if $uid {
      $_title   = "${module_name}-${name}-systemctl-user-${uid}-daemon-reload"
      $_user    = String($uid)  # exec seems unhappy with integers.
      $_env     = "XDG_RUNTIME_DIR=/run/user/${uid}"
      $_command = ['systemctl', '--user', 'daemon-reload']
    } else {
      $_title   = "${module_name}-${name}-systemctl-daemon-reload"
      $_user    = undef
      $_env     = undef
      $_command = ['systemctl', 'daemon-reload']
    }

    exec { $_title:
      command     => $_command,
      environment => $_env,
      user        => $_user,
      refreshonly => true,
      path        => $facts['path'],
    }
  }
}
