# @summary Systemd definition of amount, often bytes or united bytes
# @see https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.slice.html
#
type Systemd::Unit::AmountOrPercent = Variant[Systemd::Unit::Amount,Systemd::Unit::Percent]
