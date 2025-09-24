# @summary netdev WireGuard section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Wireguard = Struct[{
  'PrivateKey'     => Optional[String[1]],
  'PrivateKeyFile' => Optional[Stdlib::Absolutepath],
  'ListenPort'     => Optional[Variant[Integer[1,65535], Enum['auto']]],
  'FirewallMark'   => Optional[Integer[1,4294967295]],
  'RouteTable'     => Optional[Variant[String[1],Integer[1,4294967295]]],
  'RouteMetric'    => Optional[Integer[0,4294967295]],
}]
