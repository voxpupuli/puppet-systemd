# network interface definition
type Systemd::Interface = Struct[
  {
    filename => Optional[String[1]],
    network  => Optional[Systemd::Interface::Network],
    netdev   => Optional[Systemd::Interface::Netdev],
    link     => Optional[Systemd::Interface::Link],
  }
]
