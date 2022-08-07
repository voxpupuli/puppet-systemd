# @summary Possible strings for ExecStart, ExecStartPrep, ...
# @see https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.exec.html
#
type Systemd::Unit::Service::Exec = Variant[
  # Can be an empty string
  Enum[''],
  # Can be an optional prefix and absolute path
  Pattern[/^[@\-:]*(\+|!|!!)?[@\-:]*\/.*/],
  # Can be an optional prefix and a name containing no slashes
  Pattern[/^[@\-:]*(\+|!|!!)?[@\-:]*[^\/]*(\s.*)?$/]
]
