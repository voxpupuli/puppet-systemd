# Matches Systemd journald config Struct
type Systemd::JournaldSettings = Struct[
  # lint:ignore:140chars
  {
    Optional['Storage']              => Variant[Enum['volatile','persistent','auto','none'],Systemd::JournaldSettings::Ensure],
    Optional['Compress']             => Variant[Enum['yes','no'], Systemd::Unit::Amount ,Systemd::JournaldSettings::Ensure],
    Optional['Seal']                 => Variant[Enum['yes','no'],Systemd::JournaldSettings::Ensure],
    Optional['SplitMode']            => Variant[Enum['uid','none'],Systemd::JournaldSettings::Ensure],
    Optional['RateLimitInterval']    => Variant[Pattern[/^[0-9]+(s|min|h|ms|us)?$/],Systemd::JournaldSettings::Ensure],
    Optional['RateLimitIntervalSec'] => Variant[Pattern[/^[0-9]+(s|min|h|ms|us)?$/],Systemd::JournaldSettings::Ensure],
    Optional['RateLimitBurst']       => Variant[Integer[0], Pattern[/^[0-9]+$/],Systemd::JournaldSettings::Ensure],
    Optional['SystemMaxUse']         => Variant[Systemd::Unit::AmountOrPercent,Systemd::JournaldSettings::Ensure],
    Optional['SystemKeepFree']       => Variant[Systemd::Unit::AmountOrPercent,Systemd::JournaldSettings::Ensure],
    Optional['SystemMaxFileSize']    => Variant[Systemd::Unit::AmountOrPercent,Systemd::JournaldSettings::Ensure],
    Optional['SystemMaxFiles']       => Variant[Integer[0], Pattern[/^[0-9]+$/],Systemd::JournaldSettings::Ensure],
    Optional['RuntimeMaxUse']        => Variant[Systemd::Unit::AmountOrPercent ,Systemd::JournaldSettings::Ensure],
    Optional['RuntimeKeepFree']      => Variant[Systemd::Unit::AmountOrPercent ,Systemd::JournaldSettings::Ensure],
    Optional['RuntimeMaxFileSize']   => Variant[Systemd::Unit::AmountOrPercent ,Systemd::JournaldSettings::Ensure],
    Optional['RuntimeMaxFiles']      => Variant[Integer[0], Pattern[/^[0-9]+$/],Systemd::JournaldSettings::Ensure],
    Optional['MaxFileSec']           => Variant[Pattern[/^[0-9]+(year|month|week|day|h|m)?$/],Systemd::JournaldSettings::Ensure],
    Optional['MaxRetentionSec']      => Variant[Pattern[/^[0-9]+(year|month|week|day|h|m)?$/],Systemd::JournaldSettings::Ensure],
    Optional['SyncIntervalSec']      => Variant[Pattern[/^[0-9]+(year|month|week|day|h|m)?$/],Systemd::JournaldSettings::Ensure],
    Optional['ForwardToSyslog']      => Variant[Enum['yes','no'],Systemd::JournaldSettings::Ensure],
    Optional['ForwardToKMsg']        => Variant[Enum['yes','no'],Systemd::JournaldSettings::Ensure],
    Optional['ForwardToConsole']     => Variant[Enum['yes','no'],Systemd::JournaldSettings::Ensure],
    Optional['ForwardToWall']        => Variant[Enum['yes','no'],Systemd::JournaldSettings::Ensure],
    Optional['MaxLevelStore']        => Variant[Enum['emerg','alert','crit','err','warning','notice','info','debug'],Integer[0,7],Systemd::JournaldSettings::Ensure],
    Optional['MaxLevelSyslog']       => Variant[Enum['emerg','alert','crit','err','warning','notice','info','debug'],Integer[0,7],Systemd::JournaldSettings::Ensure],
    Optional['MaxLevelKMsg']         => Variant[Enum['emerg','alert','crit','err','warning','notice','info','debug'],Integer[0,7],Systemd::JournaldSettings::Ensure],
    Optional['MaxLevelConsole']      => Variant[Enum['emerg','alert','crit','err','warning','notice','info','debug'],Integer[0,7],Systemd::JournaldSettings::Ensure],
    Optional['MaxLevelWall']         => Variant[Enum['emerg','alert','crit','err','warning','notice','info','debug'],Integer[0,7],Systemd::JournaldSettings::Ensure],
    Optional['ReadKMsg']             => Variant[Enum['yes','no'],Systemd::JournaldSettings::Ensure],
    Optional['TTYPath']              => Variant[Stdlib::Absolutepath,Systemd::JournaldSettings::Ensure],
    Optional['LineMax']              => Variant[Systemd::Unit::Amount,Systemd::JournaldSettings::Ensure],
  }
  # lint:endignore
]
