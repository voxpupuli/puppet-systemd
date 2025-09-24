# @summary netdev FooOverUDP section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Foooverudp = Struct[{
  'Encapsulation'             => Optional[Enum['FooOverUDP','GenericUDPEncapsulation']],
  'Port'                      => Integer[1],
  'PeerPort'                  => Optional[Integer[1]],
  'Protocol'                  => Optional[Variant[Enum['gre','ipip'], Integer[1,255]]],
  'Peer'                      => Optional[String[1]],
  'Local'                     => Optional[String[1]],
}]
