# @summary Systemd definition of a permyriad value (‱, 1/10000)
# @see https://www.freedesktop.org/software/systemd/man/oomd.conf.html
#
type Systemd::Unit::Permyriad = Pattern['\A(0|[1-9][0-9]?[0-9]?[0-9]?|10000)‱\z']
