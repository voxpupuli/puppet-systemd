# @summary Defines allowed output values
# Used in DefaultStandardOutput/DefaultStandardError e.g.
type Systemd::Output = Enum['inherit', 'null', 'tty', 'journal', 'journal+console', 'kmsg', 'kmsg+console']
