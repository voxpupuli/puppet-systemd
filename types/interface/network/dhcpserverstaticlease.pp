# @summary interface network DHCPServerStaticLease section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Dhcpserverstaticlease = Struct[{
  'MACAddress' => String[1],
  'Address'    => String[1],
}]
