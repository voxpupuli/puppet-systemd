# @summary interface network HeavyHitterFilter section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Heavyhitterfilter = Struct[{
  'Parent'      => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Handle'      => Optional[String[1]],
  'PacketLimit' => Optional[Integer[0,4294967294]]
}]
