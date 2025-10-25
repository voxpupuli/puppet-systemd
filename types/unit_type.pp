# @summary Validates a unit types
# @see https://www.freedesktop.org/software/systemd/man/systemd.unit.html
type Systemd::Unit_type = Enum[
  'automount',
  'device',
  'mount',
  'path',
  'scope',
  'service',
  'slice',
  'socket',
  'swap',
  'target',
  'timer',
]
