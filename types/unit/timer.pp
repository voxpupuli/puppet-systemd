# @summary Possible keys for the [Timer] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.timer.html
#
type Systemd::Unit::Timer = Struct[
  {
    Optional['OnActiveSec']        => Variant[Integer[0],String,Array[Variant[Integer[0],String]]],
    Optional['OnBootSec']          => Variant[Integer[0],String,Array[Variant[Integer[0],String]]],
    Optional['OnStartUpSec']       => Variant[Integer[0],String,Array[Variant[Integer[0],String]]],
    Optional['OnUnitActiveSec']    => Variant[Integer[0],String,Array[Variant[Integer[0],String]]],
    Optional['OnUnitInactiveSec']  => Variant[Integer[0],String,Array[Variant[Integer[0],String]]],
    Optional['OnCalendar']         => Variant[Integer[0],String,Array[Variant[Integer[0],String]]],
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
