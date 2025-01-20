# @summary Possible keys for the [Link] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.link.html
#
type Systemd::Unit::Link = Struct[
  {
    Optional['MTUBytes']    => Integer[0],
  }
]
