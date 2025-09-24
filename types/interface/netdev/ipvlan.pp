# @summary netdev IPVLAN and IPVTAP section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Ipvlan = Struct[{
  'Mode'  => Optional[Enum['L2', 'L3', 'L3S']],
  'Flags' => Optional[Enum['bridge', 'private', 'vepa']],
}]
