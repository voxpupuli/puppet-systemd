# @summary interface network IPv6Prefix section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Ipv6prefix = Struct[{
  'AddressAutoconfiguration' => Optional[Enum['yes','no']],
  'OnLink'                   => Optional[Enum['yes','no']],
  'Prefix'                   => Optional[String[1]],
  'PreferredLifetimeSec'     => Optional[String[1]],
  'ValidLifetimeSec'         => Optional[String[1]],
  'Assign'                   => Optional[Enum['yes','no']],
  'Token'                    => Optional[String[1]],
  'RouteMetric'              => Optional[Integer[0, 4294967295]],
}]
