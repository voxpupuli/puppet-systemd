# @api private
#
# @summary This class provides an abstract way to set elements with timedatectl
#
# @param set_local_rtc
# Takes a boolean argument. If "false", the system is configured to maintain
# the RTC in universal time.
# If "true", it will maintain the RTC in local time instead.
# Note that maintaining the RTC in the local timezone is not fully supported
# and will create various problems with time zone changes and daylight saving
# adjustments. If at all possible, keep the RTC in UTC mode.
#
# @param timezone
# Set the system time zone to the specified value.
# Available timezones can be listed with list-timezones.
# If the RTC is configured to be in the local time, this will also update
# the RTC time. This call will alter the /etc/localtime symlink.
class systemd::timedatectl (
  Optional[Boolean] $set_local_rtc = $systemd::set_local_rtc,
  Optional[String[1]] $timezone = $systemd::timezone,
) {
  assert_private()

  if $timezone {
    exec { 'set system timezone':
      command => "timedatectl set-timezone ${timezone}",
      unless  => "test $(timedatectl show --property Timezone --value) = ${timezone}",
      path    => $facts['path'],
    }
  }

  # if $set_local_rtc is undef, this remains unmanaged
  if $set_local_rtc {
    exec { 'set local hardware clock to local time':
      command => 'timedatectl set-local-rtc 1',
      onlyif  => 'test $(timedatectl show --property LocalRTC --value) = no',
      path    => $facts['path'],
    }
  } elsif $set_local_rtc == false {
    exec { 'set local hardware clock to UTC time':
      command => 'timedatectl set-local-rtc 0',
      unless  => 'test $(timedatectl show --property LocalRTC --value) = no',
      path    => $facts['path'],
    }
  }
}
