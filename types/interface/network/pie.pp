# @summary interface network PIE section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Pie = Struct[{
  'Parent'      => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Handle'      => Optional[String[1]],
  'PacketLimit' => Optional[Integer[1,4294967294]],
}]
