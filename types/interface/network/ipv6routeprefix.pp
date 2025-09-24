# @summary interface network IPv6RoutePrefix section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Ipv6routeprefix = Struct[{
  'Route'       => Optional[String[1]],
  'LifetimeSec' => Optional[String[1]],
}]
