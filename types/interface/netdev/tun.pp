# @summary netdev Tun and Tap section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Tun = Struct[{
  'MultiQueue'  => Optional[Enum['yes','no']],
  'PacketInfo'  => Optional[Enum['yes','no']],
  'VNetHeader'  => Optional[Enum['yes','no']],
  'User'        => Optional[String[1]],
  'Group'       => Optional[String[1]],
  'KeepCarrier' => Optional[Enum['yes','no']],
}]
