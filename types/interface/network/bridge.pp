# @summary interface network Bridge section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Bridge = Struct[{
  'UnicastFlood'        => Optional[Enum['yes', 'no']],
  'MulticastFlood'      => Optional[Enum['yes', 'no']],
  'MulticastToUnicast'  => Optional[Enum['yes', 'no']],
  'NeighborSuppression' => Optional[Enum['yes', 'no']],
  'Learning'            => Optional[Enum['yes', 'no']],
  'HairPin'             => Optional[Enum['yes', 'no']],
  'Isolated'            => Optional[Enum['yes', 'no']],
  'UseBPDU'             => Optional[Enum['yes', 'no']],
  'FastLeave'           => Optional[Enum['yes', 'no']],
  'AllowPortToBeRoot'   => Optional[Enum['yes', 'no']],
  'ProxyARP'            => Optional[Enum['yes', 'no']],
  'ProxyARPWiFi'        => Optional[Enum['yes', 'no']],
  'MulticastRouter'     => Optional[Enum['no', 'query', 'permanent', 'temporary']],
  'Cost'                => Optional[Integer[1, 65535]],
  'Priority'            => Optional[Integer[0,63]],
}]
