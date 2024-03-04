# @summary Systemd definition of amount, often bytes or united bytes
# @see https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.slice.html
#
type Systemd::Unit::Amount = Variant[Integer[0],Pattern['\A(infinity|\d+(K|M|G|T)?(:\d+(K|M|G|T)?)?)\z']]
