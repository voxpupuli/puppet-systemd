# @summary netdev MACVLAN and MACVTAP section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Macvlan = Struct[{
  'Mode'                          => Optional[Enum['private', 'vepa', 'bridge', 'passthru', 'source']],
  'SourceMACAddress'              => Optional[Variant[String[1],Array[String[1]]]],
  'BroadcastMulticastQueueLength' => Optional[Integer[0,4294967294]],
  'BroadcastQueueThreshold'       => Optional[Variant[Enum['no'],Integer[0,2147483647]]],
}]
