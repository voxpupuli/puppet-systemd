# @summary netdev L2TP section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::L2tp = Struct[{
  'TunnelId'           => Integer[1,4294967295],
  'PeerTunnelId'       => Integer[1,4294967295],
  'Remote'             => String[1],
  'Local'              => Optional[Variant[Enum['auto', 'static', 'dynamic'],String[1]]],
  'EncapsulationType'  => Optional[Enum['udp','ip']],
  'UDPSourcePort'      => Optional[Integer[1]],
  'UDPDestinationPort' => Optional[Integer[1]],
  'UDPChecksum'        => Optional[Enum['yes' ,'no']],
  'UDP6ZeroChecksumTx' => Optional[Enum['yes' ,'no']],
  'UDP6ZeroChecksumRx' => Optional[Enum['yes' ,'no']],
}]
