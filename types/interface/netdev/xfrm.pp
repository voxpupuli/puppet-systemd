# @summary netdev Xfrm section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Xfrm = Struct[{
  'InterfaceId' => Optional[Variant[Integer[1],String[1]]],
  'Independent' => Optional[Enum['yes','no']],
}]
