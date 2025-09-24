# @summary interface network DeficitRoundRobinSchedulerClass section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Deficitroundrobinschedulerclass = Struct[{
  'Parent'       => Optional[Variant[Enum['root'], String[1]]],
  'ClassId'      => Optional[String[1]],
  'QuantumBytes' => Optional[String[1]],
}]
