# @summary Possible keys for the [Swap] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.swap.html
#
type Systemd::Unit::Swap = Struct[
  {
    Optional['What']           => String[1],
    Optional['Options']        => String[1],
    Optional['Priority']       => Integer,
    Optional['TimeoutSec']     => Systemd::Timespan,
    Optional['OOMScoreAdjust'] => Integer[-1000,1000],
  }
]
