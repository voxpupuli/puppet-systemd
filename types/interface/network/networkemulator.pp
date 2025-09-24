# @summary interface network NetworkEmulator section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Networkemulator = Struct[{
  'Parent'         => Optional[Variant[Enum['root', 'clsact','ingress'],String[1]]],
  'Handle'         => Optional[String[1]],
  'DelayJitterSec' => Optional[String[1]],
  'PacketLimit'    => Optional[Integer[0,4294967294]],
  'LossRate'       => Optional[String[1]],
  'DuplicateRate'  => Optional[String[1]],
}]
