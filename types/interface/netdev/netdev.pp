# @summary netdev NetDev section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Netdev = Struct[{
  'Description' => Optional[String[1]],
  'Name'        => Optional[String[1]],
  'Kind'        => Optional[String[1]],
  'MTUBytes'    => Optional[String[1]],
  'MACAddress'  => Optional[String[1]],
}]
