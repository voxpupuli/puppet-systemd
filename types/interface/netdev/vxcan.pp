# @summary netdev VXCAN section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Vxcan = Struct[{
  'Peer' => String[1],
}]
