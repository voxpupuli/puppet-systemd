# @summary netdev VLAN section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Vlan = Struct[{
  'Id'             => Optional[Integer[0,4094]],
  'Protocol'       => Optional[Enum['802.1q','802.1ad']],
  'GVRP'           => Optional[Enum['yes','no']],
  'MVRP'           => Optional[Enum['yes','no']],
  'LooseBinding'   => Optional[Enum['yes','no']],
  'ReorderHeader'  => Optional[Enum['yes','no']],
  'EgressQOSMaps'  => Optional[String[1]],
  'IngressQOSMaps' => Optional[String[1]],
}]
