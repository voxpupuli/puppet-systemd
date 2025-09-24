# @summary netdev L2TPSession section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::L2tpsession = Struct[{
  'Name'                 => String[1],
  'SessionId'            => Integer[1,4294967295],
  'PeerSessionId'        => Integer[1,4294967295],
  'Layer2SpecificHeader' => Optional[Enum['none', 'default']],
}]
