# @summary matches Systemd journal remote config Struct
type Systemd::JournalRemoteSettings = Struct[
  # lint:ignore:140chars
  {
    Optional['Seal']                   => Variant[Enum['yes','no'],Systemd::JournaldSettings::Ensure],
    Optional['SplitMode']              => Variant[Enum['host','none'],Systemd::JournaldSettings::Ensure],
    Optional['ServerKeyFile']          => Variant[Stdlib::Unixpath,Systemd::JournaldSettings::Ensure],
    Optional['ServerCertificateFile']  => Variant[Stdlib::Unixpath,Systemd::JournaldSettings::Ensure],
    Optional['TrustedCertificateFile'] => Variant[Stdlib::Unixpath,Systemd::JournaldSettings::Ensure],
    Optional['MaxUse']                 => Variant[Systemd::Unit::Amount,Systemd::JournaldSettings::Ensure],
    Optional['KeepFree']               => Variant[Systemd::Unit::Amount,Systemd::JournaldSettings::Ensure],
    Optional['MaxFileSize']            => Variant[Systemd::Unit::Amount,Systemd::JournaldSettings::Ensure],
    Optional['MaxFiles']               => Variant[Integer,Systemd::JournaldSettings::Ensure],
  }
  # lint:endignore
]
