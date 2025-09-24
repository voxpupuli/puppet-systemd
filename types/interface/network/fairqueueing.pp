# @summary interface network FairQueueing section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Fairqueueing = Struct[{
  'Parent'              => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Handle'              => Optional[String[1]],
  'PacketLimit'         => Optional[Integer[0,4294967294]],
  'FlowLimit'           => Optional[Integer[1]],
  'QuantumBytes'        => Optional[String[1]],
  'InitialQuantumBytes' => Optional[String[1]],
  'MaximumRate'         => Optional[String[1]],
  'Buckets'             => Optional[String[1]],
  'OrphanMask'          => Optional[Integer[0]],
  'Pacing'              => Optional[Enum['yes','no']],
  'CEThresholdSec'      => Optional[String[1]],
}]
