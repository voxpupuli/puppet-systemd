# @summary interface network BridgeMDB section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Bridgemdb = Struct[{
  'MulticastGroupAddress' => Optional[String[1]],
  'VLANID'                => Optional[Integer[0,4094]],
}]
