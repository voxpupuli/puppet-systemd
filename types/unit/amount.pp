# @summary Systemd definition of amount, often bytes or united bytes
# @see https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.slice.html
#
# Systemd definition of amount, often bytes or united bytes
# Some man pages are lagging behind and only report support up to Tera.
# https://github.com/systemd/systemd/blob/main/src/basic/format-util.c
# shows support for Peta and Exa.
type Systemd::Unit::Amount = Variant[Integer[0],Pattern['\A(infinity|\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)\z']]
