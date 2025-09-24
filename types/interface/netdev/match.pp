# @summary netdev match section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Match = Struct[{
  'Host'              => Optional[String[1]],
  'Virtualization'    => Optional[String[1]],
  'KernelCommandLine' => Optional[String[1]],
  'KernelVersion'     => Optional[String[1]],
  'Credential'        => Optional[String[1]],
  'Architecture'      => Optional[String[1]],
  'Firmware'          => Optional[String[1]],
}]
