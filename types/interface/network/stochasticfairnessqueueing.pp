# @summary interface network StochasticFairnessQueueing section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Stochasticfairnessqueueing = Struct[
  {
    'Parent'           => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
    'Handle'           => Optional[String[1]],
    'PerturbPeriodSec' => Optional[String[1]],
  }
]
