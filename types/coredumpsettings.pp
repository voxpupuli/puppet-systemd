# @summary Configurations for coredump.conf
# @see https://www.freedesktop.org/software/systemd/man/coredump.conf.html
#
type Systemd::CoredumpSettings = Struct[
  {
    Optional['Storage']         => Variant[Enum['none', 'external', 'journal'], Systemd::SettingEnsure],
    Optional['Compress']        => Variant[Enum['yes','no'], Systemd::SettingEnsure],
    Optional['ProcessSizeMax']  => Variant[Systemd::Unit::Amount, Systemd::SettingEnsure],
    Optional['ExternalSizeMax'] => Variant[Systemd::Unit::Amount, Systemd::SettingEnsure],
    Optional['EnterNamespace']  => Variant[Enum['yes','no'], Systemd::SettingEnsure],
    Optional['JournalSizeMax']  => Variant[Systemd::Unit::Amount, Systemd::SettingEnsure],
    Optional['MaxUse']          => Variant[Systemd::Unit::Amount, Systemd::SettingEnsure],
    Optional['KeepFree']        => Variant[Systemd::Unit::Amount, Systemd::SettingEnsure],
  }
]
