# Matches Systemd Login Manager Struct
type Systemd::LogindSettings = Struct[
  {
    Optional['HandleHibernateKey']           => Variant[Enum['ignore','poweroff','reboot','halt','kexec','suspend','hibernate','hybrid-sleep','suspend-then-hibernate','lock'],Systemd::LogindSettings::Ensure],
    Optional['HandleLidSwitch']              => Variant[Enum['ignore','poweroff','reboot','halt','kexec','suspend','hibernate','hybrid-sleep','suspend-then-hibernate','lock'],Systemd::LogindSettings::Ensure],
    Optional['HandleLidSwitchDocked']        => Variant[Enum['ignore','poweroff','reboot','halt','kexec','suspend','hibernate','hybrid-sleep','suspend-then-hibernate','lock'],Systemd::LogindSettings::Ensure],
    Optional['HandleLidSwitchExternalPower'] => Variant[Enum['ignore','poweroff','reboot','halt','kexec','suspend','hibernate','hybrid-sleep','suspend-then-hibernate','lock'],Systemd::LogindSettings::Ensure],
    Optional['HandlePowerKey']               => Variant[Enum['ignore','poweroff','reboot','halt','kexec','suspend','hibernate','hybrid-sleep','suspend-then-hibernate','lock'],Systemd::LogindSettings::Ensure],
    Optional['HandleSuspendKey']             => Variant[Enum['ignore','poweroff','reboot','halt','kexec','suspend','hibernate','hybrid-sleep','suspend-then-hibernate','lock'],Systemd::LogindSettings::Ensure],
    Optional['HibernateKeyIgnoreInhibited']  => Variant[Enum['yes','no'],Systemd::LogindSettings::Ensure],
    Optional['HoldoffTimeoutSec']            => Variant[Integer,Systemd::LogindSettings::Ensure],
    Optional['IdleAction']                   => Variant[Enum['ignore','poweroff','reboot','halt','kexec','suspend','hibernate','hybrid-sleep','suspend-then-hibernate','lock'],Systemd::LogindSettings::Ensure],
    Optional['IdleActionSec']                => Variant[Integer,Systemd::LogindSettings::Ensure],
    Optional['InhibitDelayMaxSec']           => Variant[Integer,Systemd::LogindSettings::Ensure],
    Optional['InhibitorsMax']                => Variant[Integer,Systemd::LogindSettings::Ensure],
    Optional['KillExcludeUsers']             => Variant[Array[String],Systemd::LogindSettings::Ensure],
    Optional['KillOnlyUsers']                => Variant[Array[String],Systemd::LogindSettings::Ensure],
    Optional['KillUserProcesses']            => Variant[Enum['yes','no'],Systemd::LogindSettings::Ensure],
    Optional['LidSwitchIgnoreInhibited']     => Variant[Enum['yes','no'],Systemd::LogindSettings::Ensure],
    Optional['NAutoVTs']                     => Variant[Integer,Systemd::LogindSettings::Ensure],
    Optional['PowerKeyIgnoreInhibited']      => Variant[Enum['yes','no'],Systemd::LogindSettings::Ensure],
    Optional['RemoveIPC']                    => Variant[Enum['yes','no'],Systemd::LogindSettings::Ensure],
    Optional['ReserveVT']                    => Variant[Integer,Systemd::LogindSettings::Ensure],
    Optional['RuntimeDirectorySize']         => Variant[Integer,Pattern['^(\d+(K|M|G|T|P|E|%)?)$'],Systemd::LogindSettings::Ensure],
    Optional['SessionsMax']                  => Variant[Integer,Pattern['^(infinity|(\d+(K|M|G|T|P|E|%)?))$'],Systemd::LogindSettings::Ensure],
    Optional['SuspendKeyIgnoreInhibited']    => Variant[Enum['yes','no'],Systemd::LogindSettings::Ensure],
    Optional['UserTasksMax']                 => Variant[Integer,Pattern['^(infinity|(\d+(K|M|G|T|P|E|%)?))$'],Systemd::LogindSettings::Ensure]
  }
]
