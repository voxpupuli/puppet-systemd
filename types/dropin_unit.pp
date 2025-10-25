# @summary Validates a drop-in unit name
# @see https://www.freedesktop.org/software/systemd/man/systemd.unit.html
type Systemd::Dropin_unit = Variant[
  Systemd::Unit,
  Systemd::Unit_type,
]
