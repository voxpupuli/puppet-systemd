# @summary Ensure parameter for resolved.conf settings
type Systemd::ResolvedSettings::Ensure = Struct[
  {
    Optional['ensure'] => Enum['present', 'absent'],
    Optional['value']  => Any,
  }
]
