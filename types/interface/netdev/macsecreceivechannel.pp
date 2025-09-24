# @summary netdev MACsecReceiveChannel section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Macsecreceivechannel = Struct[{
  'Port'       => Integer[1, 65535],
  'MACAddress' => String[1],
}]
