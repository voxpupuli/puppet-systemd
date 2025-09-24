# @summary interface network Address section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Address = Struct[{
  'Address'                   => String[1],
  'Peer'                      => Optional[String[1]],
  'Broadcast'                 => Optional[String[1]],
  'Label'                     => Optional[String[1,15]],
  'PreferredLifetime'         => Optional[Enum['forever', 'infinity', '0']],
  'Scope'                     => Optional[Variant[Enum['global', 'link', 'host'],Integer[0,255]]],
  'RouteMetric'               => Optional[Integer[0,4294967295]],
  'HomeAddress'               => Optional[Enum['yes', 'no']],
  'DuplicateAddressDetection' => Optional[Enum['ipv4', 'ipv6', 'both', 'none']],
  'ManageTemporaryAddress'    => Optional[Enum['yes', 'no']],
  'AddPrefixRoute'            => Optional[Enum['yes', 'no']],
  'AutoJoin'                  => Optional[Enum['yes', 'no']],
  'NetLabel'                  => Optional[String[1]],
  'NFTSet'                    => Optional[String[1]],
}]
