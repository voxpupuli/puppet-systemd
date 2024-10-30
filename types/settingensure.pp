# @summary Defines allowed ensure states for an ini_setting
type Systemd::SettingEnsure = Struct[{ 'ensure' => Enum['absent'] }]
