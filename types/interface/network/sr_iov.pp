# @summary interface network SR-IOV section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Sr_iov = Struct[
  {
    'VirtualFunction'         => Optional[Integer[0,2147483646]],
    'VLANId'                  => Optional[Integer[1,4095]],
    'QualityOfService'        => Optional[Integer[0,4294967294]],
    'VLANProtocol'            => Optional[Enum['802.1Q', '802.1ad']],
    'MACSpoofCheck'           => Optional[Enum['no','yes']],
    'QueryReceiveSideScaling' => Optional[Enum['no','yes']],
    'Trust'                   => Optional[Enum['no','yes']],
    'LinkState'               => Optional[Enum['no','yes','auto']],
    'MACAddress'              => Optional[String[1]],
  }
]
