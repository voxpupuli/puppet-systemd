# @summary defines allowed ensure states for systemd-journald settings
type Systemd::JournaldSettings::Ensure = Struct[{ 'ensure' => Enum['present','absent'] }]
