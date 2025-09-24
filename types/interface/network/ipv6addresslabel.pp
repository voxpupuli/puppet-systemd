# @summary interface network IPv6AddressLabel section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Ipv6addresslabel = Struct[{
  'Label'  => Optional[Integer[0,4294967294]],
  'Prefix' => Optional[String[1]],
}]
