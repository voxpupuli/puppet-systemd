# @summary custom datatype that validates different filenames for systemd units and unit templates
# @see https://www.freedesktop.org/software/systemd/man/systemd.unit.html
type Systemd::Unit = Pattern[/^[[a-z][A-Z][0-9]:\-_.\\@]+\.(service|socket|device|mount|automount|swap|target|path|timer|slice|scope)$/]
