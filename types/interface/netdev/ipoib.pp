# @summary netdev IPoIB section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Ipoib = Struct[{
  'PartitionKey'                  => Optional[Integer[1]],
  'Mode'                          => Optional[Enum['datagram','connected']],
  'IgnoreUserspaceMulticastGroup' => Optional[Enum['yes', 'no']],
}]
