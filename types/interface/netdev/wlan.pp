# @summary netdev WLAN section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Wlan = Struct[{
  'PhysicalDevice' => Optional[Variant[Integer[0], String[1]]],
  'Type'           => Enum['ad-hoc', 'station', 'ap', 'ap-vlan', 'wds',
  'monitor', 'mesh-point', 'p2p-client', 'p2p-go', 'p2p-device', 'ocb', 'nan'],
  'WDS'            => Optional[Enum['yes','no']],
}]
