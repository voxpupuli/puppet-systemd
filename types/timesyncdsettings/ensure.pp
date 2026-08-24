# @summary Ensure parameter for timesyncd.conf settings
type Systemd::TimesyncdSettings::Ensure = Struct[
  {
    Optional['ensure'] => Enum['present', 'absent'],
    Optional['value']  => Any,
  }
]
