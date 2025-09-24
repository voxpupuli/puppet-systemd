# @summary interface network ControlledDelay section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Controlleddelay= Struct[{
  'Parent'         => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Handle'         => Optional[String[1]],
  'PacketLimit'    => Optional[Integer[0,4294967294]],
  'TargetSec'      => Optional[String[1]],
  'IntervalSec'    => Optional[String[1]],
  'CEThresholdSec' => Optional[String[1]],
}]
