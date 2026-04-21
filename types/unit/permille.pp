# @summary Systemd definition of a permille value (‰, 1/1000)
# @see https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
#
type Systemd::Unit::Permille = Pattern['\A(0|[1-9][0-9]?[0-9]?|1000)‰\z']
