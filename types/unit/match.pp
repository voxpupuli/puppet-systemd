# @summary Possible keys for the [Match] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.link.html
#
type Systemd::Unit::Match = Struct[
  {
    Optional['Driver'] => String[1],
  }
]
