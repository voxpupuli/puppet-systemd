# @summary interface network IPoIB section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Ipoib = Struct[{
  'Mode'                          => Optional[Enum['datagram','connected']],
  'IgnoreUserspaceMulticastGroup' => Optional[Enum['yes', 'no']],
}]
