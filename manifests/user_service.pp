# @summary Manage a user service running under systemd --user
#
# @example Enable a service for all users
#  systemd::user_service { 'systemd-tmpfiles-clean.timer':
#    enable => true,
#    global => true,
#  }
#
# @example Enable a particular user's service
#  systemd::user_service { 'podman-auto-update.timer':
#    ensure => true,
#    enable => true,
#    user   => 'steve',
#  }
#
# @example Notify a user's service to restart it
#  file{ '/home/steve/.config/systemd/user/podman-auto-update.timer':
#    ensure  => file,
#    content => ...,
#    notify  => Systemd::User_service['steve-podman-auto-update.timer']
#  }
#
#  systemd::user_service { 'steve-podman-auto-update.timer':
#    ensure => true,
#    enable => true,
#    unit   => 'podman-auto-update.timer',
#    user   => 'steve',
#  }
#
#  @param unit Unit name to work on
#  @param ensure Should the unit be started or stopped. Can only be true if user is specified.
#  @param enable Should the unit be enabled or disabled
#  @param user User name of user whose unit should be acted upon. Mutually exclusive with
#  @param global Act globally for all users. Mutually exclusibe with `user`.
#
define systemd::user_service (
  Systemd::Unit $unit = $title,
  Variant[Boolean,Enum['stopped','running']] $ensure = false,
  Boolean $enable = false,
  Boolean $global = false,
  Optional[String[1]] $user = undef,
) {
  $_ensure = $ensure ? {
    'stopped' => false,
    'running' => true,
    default   => $ensure
  }

  if ( $global and $user ) or ( ! $global and ! $user) {
    fail('Exactly one of the "user" or "global" parameters must be defined')
  }

  if $global and $_ensure {
    fail('Cannot ensure a service is running for all users globally')
  }

  if $global {
    if $enable {
      $_title   = "Enable user service ${unit} globally"
      $_command = ['systemctl', '--global', 'enable', $unit]
      $_unless  = [['systemctl', '--global', 'is-enabled', $unit]]
      $_onlyif  = undef
    } else {
      $_title   = "Disable user service ${unit} globally"
      $_command = ['systemctl', '--global', 'disable', $unit]
      $_unless  = undef
      $_onlyif  = [['systemctl', '--global', 'is-enabled', $unit]]
    }
    exec { $_title:
      command => $_command,
      unless  => $_unless,
      onlyif  => $_onlyif,
      path    => $facts['path'],
    }
  } else { # per user services

    $_systemctl_user = [
      'systemd-run', '--pipe', '--wait', '--user', '--machine', "${user}@.host",
      'systemctl', '--user',
    ]

    # To accept notifies of this type.
    exec { "try-reload-or-restart-${user}-${unit}":
      command     => $_systemctl_user + ['try-reload-or-restart', $unit],
      refreshonly => true,
      path        => $facts['path'],
    }

    if $_ensure {
      $_ensure_title   = "Start user service ${unit} for user ${user}"
      $_ensure_command = $_systemctl_user + ['start', $unit]
      $_ensure_unless  = [$_systemctl_user + ['is-active', $unit]]
      $_ensure_onlyif  = undef

      # Don't reload just after starting
      Exec["try-reload-or-restart-${user}-${unit}"] -> Exec[$_ensure_title]
    } else {
      $_ensure_title   = "Stop user service ${unit} for user ${user}"
      $_ensure_command = $_systemctl_user + ['stop', $unit]
      $_ensure_unless  = undef
      $_ensure_onlyif  = [$_systemctl_user + ['is-active', $unit]]
    }

    exec { $_ensure_title:
      command => $_ensure_command,
      unless  => $_ensure_unless,
      onlyif  => $_ensure_onlyif,
      path    => $facts['path'],
    }

    if $enable {
      $_enable_title   = "Enable user service ${unit} for user ${user}"
      $_enable_command = $_systemctl_user + ['enable', $unit]
      $_enable_unless  = [$_systemctl_user + ['is-enabled', $unit]]
      $_enable_onlyif  = undef

      # Puppet does this for services so lets copy that logic
      # don't enable if you can't start.
      if $_ensure {
        Exec[$_ensure_title] -> Exec[$_enable_title]
      }
    } else {
      $_enable_title   = "Disable user service ${unit} for user ${user}"
      $_enable_command = $_systemctl_user + ['disable', $unit]
      $_enable_unless  = undef
      $_enable_onlyif  = [$_systemctl_user + ['is-enabled', $unit]]
    }

    exec { $_enable_title:
      command => $_enable_command,
      unless  => $_enable_unless,
      onlyif  => $_enable_onlyif,
      path    => $facts['path'],
    }
  }
}
