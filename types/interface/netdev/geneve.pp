# @summary netdev GENEVE section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Geneve = Struct[{
  'Id'                   => Integer[0,16777215],
  'Remote'               => Optional[String[1]],
  'TOS'                  => Optional[Integer[1,255]],
  'TTL'                  => Optional[Variant[Enum['inherit'], Integer[0,255]]],
  'UDPChecksum'          => Optional[Enum['yes', 'no']],
  'UDP6ZeroChecksumTx'   => Optional[Enum['yes', 'no']],
  'UDP6ZeroChecksumRx'   => Optional[Enum['yes', 'no']],
  'DestinationPort'      => Optional[Integer[1]],
  'FlowLabel'            => Optional[String[1]],
  'IPDoNotFragment'      => Optional[Enum['yes', 'no']],
  'InheritInnerProtocol' => Optional[Enum['yes', 'no']],
}]
