# @summary Possible keys for the [Timer] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.timer.html
#
type Systemd::Unit::Timer = Struct[
  {
    Optional['OnCalendar'] => Variant[String,Array[String,1]],
  }
]
