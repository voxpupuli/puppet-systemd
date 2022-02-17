# @summary Configurations for coredump.conf
# @see https://www.freedesktop.org/software/systemd/man/coredump.conf.html
#
type Systemd::CoredumpSettings = Struct[
  {
    Optional['Storage']         => Enum['none', 'external', 'journal'],
    Optional['Compress']        => Enum['yes','no'],
    Optional['ProcessSizeMax']  => Pattern[/^[0-9]+(K|M|G|T|P|E)?$/],
    Optional['ExternalSizeMax'] => Pattern[/^[0-9]+(K|M|G|T|P|E)?$/],
    Optional['JournalSizeMax']  => Pattern[/^[0-9]+(K|M|G|T|P|E)?$/],
    Optional['MaxUse']          => Pattern[/^[0-9]+(K|M|G|T|P|E)?$/],
    Optional['MaxFree']         => Pattern[/^[0-9]+(K|M|G|T|P|E)?$/],
  }
]
