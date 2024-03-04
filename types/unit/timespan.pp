# @summary Timer specification for systemd time spans, e.g. timers.
# @see https://www.freedesktop.org/software/systemd/man/systemd.time.html
#
type Systemd::Unit::Timespan = Variant[Integer[0],String,Array[Variant[Integer[0],String]]]
