# @summary Configurations for oomd.conf
# @see https://www.freedesktop.org/software/systemd/man/oomd.conf.html
#
type Systemd::OomdSettings = Struct[
  {
    Optional['SwapUsedLimit']                    => Pattern[/^[0-9]+[%|‰|‱]$/],
    Optional['DefaultMemoryPressureLimit']       => Pattern[/^[0-9]+%$/],
    Optional['DefaultMemoryPressureDurationSec'] => Integer[0],
  }
]
