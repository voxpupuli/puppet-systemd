# @summary Possible keys for the [Timer] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.timer.html
#
type Systemd::Unit::Timer = Struct[
  {
    Optional['OnActiveSec']        => Systemd::Unit::Timespan,
    Optional['OnBootSec']          => Systemd::Unit::Timespan,
    Optional['OnStartUpSec']       => Systemd::Unit::Timespan,
    Optional['OnUnitActiveSec']    => Systemd::Unit::Timespan,
    Optional['OnUnitInactiveSec']  => Systemd::Unit::Timespan,
    Optional['OnCalendar']         => Systemd::Unit::Timespan,
    Optional['AccuracySec']        => Variant[Integer[0],String],
    Optional['RandomizedDelaySec'] => Variant[Integer[0],String],
    Optional['FixedRandomDelay']   => Boolean,
    Optional['OnClockChange']      => Boolean,
    Optional['OnTimezoneChange']   => Boolean,
    Optional['Unit']               => Systemd::Unit,
    Optional['Persistent']         => Boolean,
    Optional['WakeSystem']         => Boolean,
    Optional['RemainAfterElapse']  => Boolean,
  }
]
