# @summary defines allowed ensure states for systemd-logind settings
type Systemd::LogindSettings::Ensure = Struct[{ 'ensure' => Enum['present','absent'] }]
