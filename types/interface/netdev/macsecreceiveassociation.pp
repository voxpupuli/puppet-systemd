# @summary netdev MACsecReceiveAssociation section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Macsecreceiveassociation = Struct[{
  'Port'       => Integer[1, 65535],
  'MACAddress' => String[1],
  'PacketNumber'   => Optional[Variant[Integer[1,4],Integer[294,295],Integer[967,967]]],
  'KeyId'          => Optional[Integer[0,255]],
  'Key'            => Optional[String[1]],
  'KeyFile'        => Optional[String[1]],
  'Activate'       => Optional[Enum['yes','no']],
}]
