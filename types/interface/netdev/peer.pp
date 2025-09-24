# @summary netdev Peer section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Peer = Struct[{
  'Name' => String[1],
  'MACAddress' => Optional[String[1]],
}]
