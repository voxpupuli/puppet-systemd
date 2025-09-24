# @summary interface network GenericRandomEarlyDetection section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Genericrandomearlydetection = Struct[{
  'Parent'               => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Handle'               => Optional[String[1]],
  'VirtualQueues'        => Optional[Integer[1,16]],
  'DefaultVirtualQueues' => Optional[Integer[1,16]],
  'GenericRIO'           => Optional[Enum['yes','no']],
}]
