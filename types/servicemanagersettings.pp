# @summary Matches Systemd system.conf/user.conf settings
#
# NOTE: Systemd::SettingEnsure here allows to delete the setting from the INI
# file. See the example below for Hiera:
#
# ```yaml
# systemd::system_settings:
#   LogLevel:
#     ensure: absent
# ```
#
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd-system.conf.html
type Systemd::ServiceManagerSettings = Struct[
  # lint:ignore:140chars
  {
    Optional['LogLevel'] => Variant[Systemd::LogLevel, Systemd::SettingEnsure],
    Optional['LogTarget'] => Variant[Enum['console','console-prefixed','kmsg','journal','journal-or-kmsg','auto','null'], Systemd::SettingEnsure],
    Optional['LogColor'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['LogLocation'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['LogTime'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['DumpCore'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['ShowStatus'] => Variant[Systemd::Boolean, Enum['auto','error'], Systemd::SettingEnsure],
    Optional['CrashChangeVT'] => Variant[Systemd::Boolean, Integer[1,63], Systemd::SettingEnsure],
    Optional['CrashShell'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['CrashReboot'] => Variant[Systemd::Boolean, Systemd::SettingEnsure], # Obsoleted by CrashAction in v256, delete after Debian 12 EOL
    Optional['CrashAction'] => Variant[Enum['freeze', 'reboot', 'poweroff'], Systemd::SettingEnsure],
    Optional['CtrlAltDelBurstAction'] => Variant[Enum['reboot-force','poweroff-force','reboot-immediate','poweroff-immediate','none'], Systemd::SettingEnsure],
    Optional['CPUAffinity'] => Variant[Enum['numa'], Pattern['^[0-9, -]+$'], Systemd::SettingEnsure],
    Optional['NUMAPolicy'] => Variant[Enum['default','preferred','bind','interleave','local'], Systemd::SettingEnsure],
    Optional['NUMAMask'] => Variant[Enum['all'], Pattern['^[0-9, -]+$'], Systemd::SettingEnsure],
    Optional['RuntimeWatchdogSec'] => Variant[Enum['off','default'], Systemd::Timespan, Systemd::SettingEnsure],
    Optional['RuntimeWatchdogPreSec'] => Variant[Enum['off'], Systemd::Timespan, Systemd::SettingEnsure],
    Optional['RuntimeWatchdogPreGovernor'] => Variant[Enum['noop', 'panic'], String[1], Systemd::SettingEnsure],
    Optional['RebootWatchdogSec'] => Variant[Enum['off','default'], Systemd::Timespan, Systemd::SettingEnsure],
    Optional['KExecWatchdogSec'] => Variant[Enum['off','default'], Systemd::Timespan, Systemd::SettingEnsure],
    Optional['WatchdogDevice'] => Variant[Stdlib::Absolutepath, Systemd::SettingEnsure],
    Optional['CapabilityBoundingSet'] => Variant[Systemd::Capabilities, Systemd::SettingEnsure],
    Optional['NoNewPrivileges'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['ProtectSystem'] => Variant[Enum['auto'], Systemd::Boolean, Systemd::SettingEnsure],
    Optional['SystemCallArchitectures'] => Variant[String[1], Systemd::SettingEnsure],
    Optional['TimerSlackNSec'] => Variant[Systemd::Timespan, Systemd::SettingEnsure],
    Optional['StatusUnitFormat'] => Variant[Enum['combined','description','name'], Systemd::SettingEnsure],
    Optional['DefaultTimerAccuracySec'] => Variant[Systemd::Timespan, Systemd::SettingEnsure],
    Optional['DefaultStandardOutput'] => Variant[Systemd::Output, Systemd::SettingEnsure],
    Optional['DefaultStandardError'] => Variant[Systemd::Output, Systemd::SettingEnsure],
    Optional['DefaultTimeoutStartSec'] => Variant[Systemd::Timespan, Systemd::SettingEnsure],
    Optional['DefaultTimeoutStopSec'] => Variant[Systemd::Timespan, Systemd::SettingEnsure],
    Optional['DefaultTimeoutAbortSec'] => Variant[Systemd::Timespan, Systemd::SettingEnsure],
    Optional['DefaultDeviceTimeoutSec'] => Variant[Systemd::Timespan, Systemd::SettingEnsure],
    Optional['DefaultRestartSec'] => Variant[Systemd::Timespan, Systemd::SettingEnsure],
    Optional['DefaultStartLimitIntervalSec'] => Variant[Enum['infinity'], Systemd::Timespan, Systemd::SettingEnsure],
    Optional['DefaultStartLimitBurst'] => Variant[Integer[0], Systemd::SettingEnsure],
    Optional['DefaultEnvironment'] => Variant[String, Systemd::SettingEnsure],
    Optional['ManagerEnvironment'] => Variant[String, Systemd::SettingEnsure],
    Optional['DefaultCPUAccounting'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['DefaultBlockIOAccounting'] => Variant[Systemd::Boolean, Systemd::SettingEnsure], # Deprecated in v252. Delete after Debian 11 EOL
    Optional['DefaultIOAccounting'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['DefaultIPAccounting'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['DefaultMemoryAccounting'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['DefaultTasksAccounting'] => Variant[Systemd::Boolean, Systemd::SettingEnsure],
    Optional['DefaultTasksMax'] => Variant[Enum['infinity'], Integer[0], Systemd::Unit::Percent, Systemd::SettingEnsure],
    Optional['DefaultLimitCPU'] => Variant[Enum['infinity'], Pattern['^\d+(s|m|h|d|w|M|y)?(:\d+(s|m|h|d|w|M|y)?)?$'], Systemd::SettingEnsure],
    Optional['DefaultLimitFSIZE'] => Variant[Pattern['^(infinity|((\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)))$'], Systemd::SettingEnsure],
    Optional['DefaultLimitDATA'] => Variant[Pattern['^(infinity|((\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)))$'], Systemd::SettingEnsure],
    Optional['DefaultLimitSTACK'] => Variant[Pattern['^(infinity|((\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)))$'], Systemd::SettingEnsure],
    Optional['DefaultLimitCORE'] => Variant[Pattern['^(infinity|((\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)))$'], Systemd::SettingEnsure],
    Optional['DefaultLimitRSS'] => Variant[Pattern['^(infinity|((\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)))$'], Systemd::SettingEnsure],
    Optional['DefaultLimitNOFILE'] => Variant[Integer[-1], Pattern['^(infinity|\d+(:(infinity|\d+))?)$'], Systemd::SettingEnsure],
    Optional['DefaultLimitAS'] => Variant[Pattern['^(infinity|((\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)))$'], Systemd::SettingEnsure],
    Optional['DefaultLimitNPROC'] => Variant[Integer[-1],Pattern['^(infinity|\d+(:(infinity|\d+))?)$'], Systemd::SettingEnsure],
    Optional['DefaultLimitMEMLOCK'] => Variant[Pattern['^(infinity|((\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)))$'], Systemd::SettingEnsure],
    Optional['DefaultLimitLOCKS'] => Variant[Integer[1], Systemd::SettingEnsure],
    Optional['DefaultLimitSIGPENDING'] => Variant[Integer[1], Systemd::SettingEnsure],
    Optional['DefaultLimitMSGQUEUE'] => Variant[Pattern['^(infinity|((\d+(K|M|G|T|P|E)?(:\d+(K|M|G|T|P|E)?)?)))$'], Systemd::SettingEnsure],
    Optional['DefaultLimitNICE'] => Variant[Integer[0,40], Pattern['^(-\+([0-1]?[0-9]|20))|([0-3]?[0-9]|40)$'], Systemd::SettingEnsure],
    Optional['DefaultLimitRTPRIO'] => Variant[Integer[0], Systemd::SettingEnsure],
    Optional['DefaultLimitRTTIME'] => Variant[Pattern['^\d+(ms|s|m|h|d|w|M|y)?(:\d+(ms|s|m|h|d|w|M|y)?)?$'], Systemd::SettingEnsure],
    Optional['DefaultOOMPolicy'] => Variant[Enum['continue', 'stop','kill'], Systemd::SettingEnsure],
    Optional['DefaultSmackProcessLabel'] => Variant[String, Systemd::SettingEnsure],
    Optional['ReloadLimitIntervalSec'] => Variant[Enum['infinity'], Systemd::Timespan, Systemd::SettingEnsure],
    Optional['ReloadLimitBurst'] => Variant[Integer[0], Systemd::SettingEnsure],
    Optional['DefaultMemoryPressureWatch'] => Variant[Systemd::SettingEnsure],
    Optional['DefaultMemoryPressureThresholdSec'] => Variant[Systemd::SettingEnsure],
  }
  # lint:endignore
]
