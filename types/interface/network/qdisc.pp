# @summary interface network QDisc section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Qdisc = Struct[{
  'Parent' => Optional[Enum['clsact', 'ingress']],
  'Handle' => Optional[String[1]],
}]
