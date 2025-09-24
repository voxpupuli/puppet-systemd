# @summary Network device configuration(Link) Match section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.link.html
type Systemd::Interface::Link::Match = Struct[{
  'Name'                => Optional[String[1]],
  'MACAddress'          => Optional[String[1]],
  'PermanentMACAddress' => Optional[String[1]],
  'Path'                => Optional[String[1]],
  'Driver'              => Optional[String[1]],
  'Type'                => Optional[String[1]],
  'Kind'                => Optional[String[1]],
  'Property'            => Optional[String[1]],
  'OriginalName'        => Optional[String[1]],
  'SSID'                => Optional[String[1]],
  'BSSID'               => Optional[String[1]],
  'Host'                => Optional[String[1]],
  'Virtualization'      => Optional[String[1]],
  'KernelCommandLine'   => Optional[String[1]],
  'KernelVersion'       => Optional[String[1]],
  'Credential'          => Optional[String[1]],
  'Architecture'        => Optional[String[1]],
  'Firmware'            => Optional[String[1]],
}]
