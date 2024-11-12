# @summary matches Systemd journal upload config Struct
type Systemd::JournalUploadSettings = Struct[
  # lint:ignore:140chars
  {
    Optional['URL']                    => Variant[Stdlib::HTTPUrl,Systemd::JournaldSettings::Ensure],
    Optional['ServerKeyFile']          => Variant[Stdlib::Unixpath,Systemd::JournaldSettings::Ensure],
    Optional['ServerCertificateFile']  => Variant[Stdlib::Unixpath,Systemd::JournaldSettings::Ensure],
    Optional['TrustedCertificateFile'] => Variant[Stdlib::Unixpath,Systemd::JournaldSettings::Ensure],
    Optional['NetworkTimeoutSec']      => Variant[Systemd::Unit::Timespan,Systemd::JournaldSettings::Ensure],
  }
  # lint:endignore
]
