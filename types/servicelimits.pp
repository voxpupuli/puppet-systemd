# Matches Systemd Service Limit Struct
type Systemd::ServiceLimits = Struct[
  {
    Optional['LimitCPU']        => Pattern['^\d+(s|m|h|d|w|M|y)?(:\d+(s|m|h|d|w|M|y)?)?$'],
    Optional['LimitFSIZE']      => Pattern['^(infinity|((\d+(K|M|G|T|P|E)(:\d+(K|M|G|T|P|E))?)))$'],
    Optional['LimitDATA']       => Pattern['^(infinity|((\d+(K|M|G|T|P|E)(:\d+(K|M|G|T|P|E))?)))$'],
    Optional['LimitSTACK']      => Pattern['^(infinity|((\d+(K|M|G|T|P|E)(:\d+(K|M|G|T|P|E))?)))$'],
    Optional['LimitCORE']       => Pattern['^(infinity|((\d+(K|M|G|T|P|E)(:\d+(K|M|G|T|P|E))?)))$'],
    Optional['LimitRSS']        => Pattern['^(infinity|((\d+(K|M|G|T|P|E)(:\d+(K|M|G|T|P|E))?)))$'],
    Optional['LimitNOFILE']     => Integer[0],
    Optional['LimitAS']         => Pattern['^(infinity|((\d+(K|M|G|T|P|E)(:\d+(K|M|G|T|P|E))?)))$'],
    Optional['LimitNPROC']      => Integer[1],
    Optional['LimitMEMLOCK']    => Pattern['^(infinity|((\d+(K|M|G|T|P|E)(:\d+(K|M|G|T|P|E))?)))$'],
    Optional['LimitLOCKS']      => Integer[1],
    Optional['LimitSIGPENDING'] => Integer[1],
    Optional['LimitMSGQUEUE']   => Pattern['^(infinity|((\d+(K|M|G|T|P|E)(:\d+(K|M|G|T|P|E))?)))$'],
    Optional['LimitNICE']       => Variant[Integer[0,40], Pattern['^(-\+([0-1]?[0-9]|20))|([0-3]?[0-9]|40)$']],
    Optional['LimitRTPRIO']     => Integer[0],
    Optional['LimitRTTIME']     => Pattern['^\d+(ms|s|m|h|d|w|M|y)?(:\d+(ms|s|m|h|d|w|M|y)?)?$']
  }
]
