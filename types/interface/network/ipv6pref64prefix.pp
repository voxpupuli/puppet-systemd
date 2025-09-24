# @summary interface network IPv6PREF64Prefix section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Ipv6pref64prefix = Struct[{
  'Prefix'       => Optional[String[1]],
  'LifetimeSec' => Optional[String[1]],
}]
