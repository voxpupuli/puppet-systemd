# @summary interface network BFIFO section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Bfifo = Struct[{
  'Parent'     => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Handle'     => Optional[String[1]],
  'LimitBytes' => Optional[String[1]],
}]
