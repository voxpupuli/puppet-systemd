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
# @param user
#   Specify user name of `systemd --user` to reload. This not supported **below** Redhat 9,
#   Ubuntu 22.04 or Debian 12.
#
# @example Force reload the system systemd
#   notify{ 'fake event to notify from':
#     notify => Systemd::Daemon_reload['special']
#   }
#   systemd::daemon_reload{ 'special': }
#
# @example Force reload a systemd --user
#   notify{ 'fake event to notify from':
#     notify => Systemd::Daemon_reload['steve_user']
#   }
#   systemd::daemon_reload{ 'steve_user':
#     user => 'steve',
#   }
#
define systemd::daemon_reload (
  Boolean $enable = true,
  Optional[String[1]] $user = undef,
) {
  include systemd

  if $enable {
    if $user {
      if ($facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'],'9') < 0 ) or
      ($facts['os']['name'] == 'Debian' and versioncmp($facts['os']['release']['major'],'12') < 0 ) or
      ($facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'],'22.04') < 0 ) {
        fail('systemd::daemon_reload_for a user is not supported below RedHat 9, Debian 12 or Ubuntu 22.04')
      }

      $_title   = "${module_name}-${name}-systemctl-user-${user}-daemon-reload"
      $_command = ['systemd-run', '--pipe', '--wait', '--user', '--machine', "${user}@.host", 'systemctl', '--user', 'daemon-reload']
    } else {
      $_title   = "${module_name}-${name}-systemctl-daemon-reload"
      $_command = ['systemctl', 'daemon-reload']
    }

    exec { $_title:
      command     => $_command,
      refreshonly => true,
      path        => $facts['path'],
    }
  }
}
