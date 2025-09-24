# @summary netdev BareUDP section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Bareudp = Struct[{
  'DestinationPort' => Integer[1, 65535],
  'EtherType'       => Enum['ipv4', 'ipv6', 'mpls-uc', 'mpls-mc'],
}]
