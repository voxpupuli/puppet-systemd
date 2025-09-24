# @summary netdev MACsec section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Macsec = Struct[{
  'Port' => Optional[Integer[1, 65535]],
  'Encrypt' => Optional[Enum['yes','no']],
}]
