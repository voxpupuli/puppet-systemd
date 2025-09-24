# @summary interface network LLDP section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Lldp = Struct[{
  'MUDURL' => Optional[String[1]],
}]
