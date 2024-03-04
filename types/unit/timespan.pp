# @summary Timer specification for systemd timers
# @see https://www.freedesktop.org/software/systemd/man/systemd.time.html
#
type Systemd::Unit::Timespan = Variant[Integer[0],String,Array[Variant[Integer[0],String]]]
