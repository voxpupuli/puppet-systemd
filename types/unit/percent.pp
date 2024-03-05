# @summary Systemd definition of a percentage
# @see https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.slice.html
#
type Systemd::Unit::Percent = Pattern['\A([0-9][0-9]?|100)%\z']
