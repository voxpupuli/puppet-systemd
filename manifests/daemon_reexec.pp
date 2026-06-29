# @summary Run systemctl daemon-reexec
#
# @api public
#
# Re-executes the systemd manager so that changes to its own configuration
# (system.conf/user.conf and their drop-ins) take effect.
#
# @param name
#   A globally unique name for the resource
#
# @param enable
#   Enable the reexec exec
#   * Added in case users want to disable the reexec globally using a resource collector
#
# @param user
#   Specify user name of `systemd --user` to reexec. This is not supported **below** Redhat 9,
#   Ubuntu 22.04 or Debian 12.
#
# @example Force reexec the system systemd
#   notify { 'fake event to notify from':
#     notify => Systemd::Daemon_reexec['special']
#   }
#   systemd::daemon_reexec { 'special': }
#
# @example Force reexec a systemd --user
#   notify { 'fake event to notify from':
#     notify => Systemd::Daemon_reexec['steve_user']
#   }
#   systemd::daemon_reexec { 'steve_user':
#     user => 'steve',
#   }
#
define systemd::daemon_reexec (
  Boolean $enable = true,
  Optional[String[1]] $user = undef,
) {
  include systemd

  if $enable {
    if $user {
      if ($facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'],'9') < 0 ) {
        fail('systemd::daemon_reexec for a user is not supported below RedHat 9')
      }

      $_title   = "${module_name}-${name}-systemctl-user-${user}-daemon-reexec"
      $_command = systemd::systemctl_user($user, ['daemon-reexec'])
    } else {
      $_title   = "${module_name}-${name}-systemctl-daemon-reexec"
      $_command = ['systemctl', 'daemon-reexec']
    }

    exec { $_title:
      command     => $_command,
      refreshonly => true,
      path        => $facts['path'],
      before      => Anchor['systemd::reexec_before_reload'],
    }
  }
}
