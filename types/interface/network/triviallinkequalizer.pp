# @summary interface network TrivialLinkEqualizer section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Triviallinkequalizer= Struct[
  {
    'Parent'        => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
    'Handle'        => Optional[String[1]],
    'DefaultClass'  => Optional[String[1]],
    'RateToQuantum' => Optional[Integer[0]]
  }
]
