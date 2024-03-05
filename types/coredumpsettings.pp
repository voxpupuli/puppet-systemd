# @summary Configurations for coredump.conf
# @see https://www.freedesktop.org/software/systemd/man/coredump.conf.html
#
type Systemd::CoredumpSettings = Struct[
  {
    Optional['Storage']         => Enum['none', 'external', 'journal'],
    Optional['Compress']        => Enum['yes','no'],
    Optional['ProcessSizeMax']  => Systemd::Unit::Amount,
    Optional['ExternalSizeMax'] => Systemd::Unit::Amount,
    Optional['JournalSizeMax']  => Systemd::Unit::Amount,
    Optional['MaxUse']          => Systemd::Unit::Amount,
    Optional['KeepFree']        => Systemd::Unit::Amount,
  }
]
