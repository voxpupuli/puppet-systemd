# @summary Configurations for oomd.conf
# @see https://www.freedesktop.org/software/systemd/man/oomd.conf.html
#
type Systemd::OomdSettings = Struct[
  {
    Optional['SwapUsedLimit']                    => Variant[Systemd::Unit::Percent,Systemd::Unit::Permille,Systemd::Unit::Permyriad,Systemd::SettingEnsure],
    Optional['DefaultMemoryPressureLimit']       => Variant[Systemd::Unit::Percent,Systemd::Unit::Permille,Systemd::Unit::Permyriad,Systemd::SettingEnsure],
    Optional['DefaultMemoryPressureDurationSec'] => Variant[Systemd::Timespan,Systemd::SettingEnsure],
  }
]
