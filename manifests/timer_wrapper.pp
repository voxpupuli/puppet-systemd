# @summary
#   Helper to define timer and accompanying services for a given task (cron like interface).
# @param ensure whether the timer and service should be present or absent
# @param command the command for the systemd servie to execute
# @param user the user to run the command as
# @param on_active_sec run service relative to the time when the timer was activated
# @param on_boot_sec run service relative to when the machine was booted
# @param on_start_up_sec run service relative to when the service manager was started
# @param on_unit_active_sec run service relative to when the unit was last activated
# @param on_unit_inactive_sec run service relative to when the unit was last deactivated
# @param on_calendar the calendar event expressions time to run the service
# @param service_overrides override for the`[Service]` section of the service
# @param timer_overrides override for the`[Timer]` section of the timer
# @param service_unit_overrides override for the`[Unit]` section of the service
# @param timer_unit_overrides override for the `[Unit]` section of the timer
# @example Create a timer that runs every 5 minutes
#   systemd::timer_wrapper { 'my_timer':
#     ensure        => 'present',
#     command       => '/usr/bin/echo "Hello World"',
#     on_calendar   => '*:0/5',
#   }
# @example Create a timer with overrides for the service and timer
#   systemd::timer_wrapper { 'my_timer':
#     ensure             => 'present',
#     command            => '/usr/bin/echo "Hello World"',
#     on_calendar        => '*:0/5',
#     service_overrides => { 'Group' => 'nobody' },
#     timer_overrides   => { 'OnBootSec' => '10' },
#   }
# @example Create a timer with overrides for the service_unit and timer_unit
#   systemd::timer_wrapper { 'my_timer':
#     ensure                 => 'present',
#     command                => '/usr/bin/echo "Hello World"',
#     on_calendar            => '*:0/5',
#     service_unit_overrides => { 'Wants' => 'network-online.target' },
#     timer_unit_overrides   => { 'Description' => 'Very special timer' },
#   }
define systemd::timer_wrapper (
  Enum['present', 'absent']              $ensure,
  Optional[Systemd::Unit::Service::Exec] $command = undef,
  Optional[String[1]]                    $user = undef,
  Optional[Systemd::Unit::Timespan]      $on_active_sec = undef,
  Optional[Systemd::Unit::Timespan]      $on_boot_sec = undef,
  Optional[Systemd::Unit::Timespan]      $on_start_up_sec = undef,
  Optional[Systemd::Unit::Timespan]      $on_unit_active_sec = undef,
  Optional[Systemd::Unit::Timespan]      $on_unit_inactive_sec = undef,
  Optional[Systemd::Unit::Timespan]      $on_calendar = undef,
  Systemd::Unit::Service                 $service_overrides         = {},
  Systemd::Unit::Timer                   $timer_overrides           = {},
  Systemd::Unit::Unit                    $timer_unit_overrides      = {},
  Systemd::Unit::Unit                    $service_unit_overrides    = {},
) {
  $_timer_spec = {
    'OnActiveSec'       => $on_active_sec,
    'OnBootSec'         => $on_boot_sec,
    'OnStartUpSec'      => $on_start_up_sec,
    'OnUnitActiveSec'   => $on_unit_active_sec,
    'OnUnitInactiveSec' => $on_unit_inactive_sec,
    'OnCalendar'        => $on_calendar,
  }.filter |$k, $v| { $v =~ NotUndef }

  if $ensure == 'present' {
    if $_timer_spec == {} {
      fail('At least one of on_active_sec,
        on_boot_sec,
        on_start_up_sec,
        on_unit_active_sec,
        on_unit_inactive_sec,
        or on_calendar must be set'
      )
    }
    if ! $command {
      fail('command must be set')
    }
  }

  $service_ensure = $ensure ? { 'absent' => false,  default  => true, }

  systemd::manage_unit { "${title}.service":
    ensure        => $ensure,
    unit_entry    => $service_unit_overrides,
    service_entry => {
      'ExecStart' => $command, # if ensure present command is defined is checked above
      'User'      => $user, # defaults apply
      'Type'      => 'oneshot',
    }.filter |$key, $val| { $val =~ NotUndef } + $service_overrides,
  }
  systemd::manage_unit { "${title}.timer":
    ensure        => $ensure,
    unit_entry    => $timer_unit_overrides,
    timer_entry   => $_timer_spec +  $timer_overrides,
    install_entry => {
      'WantedBy' => 'timers.target',
    },
  }

  service { "${title}.timer":
    ensure => $service_ensure,
    enable => $service_ensure,
  }

  if $ensure == 'present' {
    Systemd::Manage_unit["${title}.service"]
    -> Systemd::Manage_unit["${title}.timer"]
    -> Service["${title}.timer"]
  } else {
    # Ensure the timer is stopped and disabled before the service
    Service["${title}.timer"]
    -> Systemd::Manage_unit["${title}.timer"]
    -> Systemd::Manage_unit["${title}.service"]
  }
}
