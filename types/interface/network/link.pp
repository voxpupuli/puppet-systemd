# @summary interface network Link section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Link = Struct[{
  'MACAddress'              => Optional[String[1]],
  'MTUBytes'                => Optional[Integer[1280]],
  'ARP'                     => Optional[Enum['yes','no']],
  'Multicast'               => Optional[Enum['yes','no']],
  'AllMulticast'            => Optional[Enum['yes','no']],
  'Promiscuous'             => Optional[Enum['yes','no']],
  'Unmanaged'               => Optional[Enum['yes','no']],
  'Group'                   => Optional[Integer[0,2147483647]],
  'RequiredForOnline'       => Optional[String[1]],
  'RequiredFamilyForOnline' => Optional[Enum['no', 'ipv4', 'ipv6', 'both', 'any']],
  'ActivationPolicy'        => Optional[Enum[
    'up', 'always-up', 'manual', 'always-down', 'down', 'bound'
  ]],
}]
