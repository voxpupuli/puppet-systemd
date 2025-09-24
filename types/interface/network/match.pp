# @summary interface network Match section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Match = Struct[{
  'MACAddress'          => Optional[String[1]],
  'PermanentMACAddress' => Optional[String[1]],
  'Path'                => Optional[String[1]],
  'Driver'              => Optional[String[1]],
  'Type'                => Optional[String[1]],
  'Kind'                => Optional[String[1]],
  'Property'            => Optional[String[1]],
  'Name'                => Optional[String[1]],
  'WLANInterfaceType'   => Optional[Enum[
    'ad-hoc', 'station', 'ap', 'ap-vlan', 'wds', 'monitor',
    'mesh-point', 'p2p-client', 'p2p-go', 'p2p-device', 'ocb', 'nan',
    '!ad-hoc', '!station', '!ap', '!ap-vlan', '!wds', '!monitor',
    '!mesh-point', '!p2p-client', '!p2p-go', '!p2p-device', '!ocb', '!nan'
  ]],
  'SSID'                => Optional[String[1]],
  'BSSID'               => Optional[String[1]],
  'Host'                => Optional[String[1]],
  'Virtualization'      => Optional[String[1]],
  'KernelCommandLine'   => Optional[String[1]],
  'KernelVersion'       => Optional[String[1]],
  'Credential'          => Optional[String[1]],
  'Architecture'        => Optional[String[1]],
  'Firmware'            => Optional[String[1]],
}]
