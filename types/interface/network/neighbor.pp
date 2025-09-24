# @summary interface network Neighbor section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Neighbor = Struct[{
  'Address'          => Optional[String[1]],
  'LinkLayerAddress' => Optional[String[1]],
}]
