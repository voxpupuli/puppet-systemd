# @summary interface network FairQueueingControlledDelay section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Fairqueueingcontrolleddelay = Struct[{
  'Parent'           => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Handle'           => Optional[String[1]],
  'PacketLimit'      => Optional[Integer[0,4294967294]],
  'MemoryLimitBytes' => Optional[String[1]],
  'Flows'            => Optional[String[1]],
  'TargetSec'        => Optional[String[1]],
  'IntervalSec'      => Optional[String[1]],
  'QuantumBytes'     => Optional[String[1]],
  'ECN'              => Optional[Enum['yes','no']],
  'CEThresholdSec'   => Optional[String[1]],
}]
