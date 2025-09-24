# @summary interface network NextHop section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Nexthop = Struct[{
  'Id'        => Optional[Integer[1, 4294967295]],
  'Gateway'   => Optional[Variant[Array[String[1]], String[1]]],
  'Familiy'   => Optional[Enum['ipv4','ipv6']],
  'OnLink'    => Optional[Enum['yes','no']],
  'Blackhole' => Optional[Enum['yes','no']],
  'Group'     => Optional[String[1]],
}]
