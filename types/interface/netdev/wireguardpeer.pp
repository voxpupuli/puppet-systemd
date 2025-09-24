# @summary netdev WireGuard section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Wireguardpeer = Struct[{
  'PublicKey'           => Optional[String[1]],
  'PresharedKey'        => Optional[String[1]],
  'PresharedKeyFile'    => Optional[Stdlib::Absolutepath],
  'AllowedIPs'          => Optional[Variant[String, Array[String]]],
  'Endpoint'            => Optional[String[1]],
  'PersistentKeepalive' => Optional[Variant[Integer[0,65535],Enum['off']]],
  'RouteTable'          => Optional[Variant[Integer[0,4294967295],String[1]]],
  'RouteMetric'         => Optional[Integer[0,4294967295]],
}]
