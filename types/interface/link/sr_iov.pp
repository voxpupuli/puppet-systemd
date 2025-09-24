# @summary Network device configuration(Link) SR-IOV section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.link.html
type Systemd::Interface::Link::Sr_iov = Struct[{
  'VirtualFunction'         => Optional[Integer[0,2147483646]],
  'VLANId'                  => Optional[Integer[1,4095]],
  'QualityOfService'        => Optional[Integer[1,4294967294]],
  'VLANProtocol'            => Optional[Enum['802.1Q', '802.1ad']],
  'MACSpoofCheck'           => Optional[Enum['yes','no']],
  'QueryReceiveSideScaling' => Optional[Enum['yes','no']],
  'Trust'                   => Optional[Enum['yes','no']],
  'LinkState'               => Optional[Enum['yes','no','auto']],
  'MACAddress'              => Optional[String[1]],
}]
