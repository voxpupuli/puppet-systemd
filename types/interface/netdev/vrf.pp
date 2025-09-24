# @summary netdev VRF section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Vrf = Struct[{
  'Table' => Integer[0],
}]
