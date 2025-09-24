# @summary interface network BridgeVLAN section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Bridgevlan = Struct[{
  'VLAN'           => Optional[Variant[String[1], Array[String[1]]]],
  'EgressUntagged' => Optional[Variant[String[1], Array[String[1]]]],
  'PVID'           => Optional[Variant[Enum['no','false'],Integer[1]]],
}]
