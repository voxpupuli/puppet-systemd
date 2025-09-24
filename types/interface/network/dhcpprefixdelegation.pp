# @summary interface network DHCPPrefixDelegation section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Dhcpprefixdelegation = Struct[{
  'UplinkInterface'        => Optional[String[1]],
  'SubnetId'               => Optional[String[1]],
  'Announce'               => Optional[Enum['yes','no']],
  'Assign'                 => Optional[Enum['yes','no']],
  'Token'                  => Optional[String[1]],
  'ManageTemporaryAddress' => Optional[Enum['yes', 'no']],
  'RouteMetric'            => Optional[Integer[0,4294967295]],
  'NetLabel'               => Optional[String[1]],
  'NFTSet'                 => Optional[String[1]],
}]
