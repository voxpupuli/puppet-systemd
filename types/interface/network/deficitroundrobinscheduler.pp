# @summary interface network DeficitRoundRobinScheduler section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Deficitroundrobinscheduler= Struct[{
    'Parent'      => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
    'Handle'      => Optional[String[1]],
}]
