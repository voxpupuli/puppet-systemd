# @summary interface network EnhancedTransmissionSelection section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Enhancedtransmissionselection = Struct[{
  'Parent'       => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Handle'       => Optional[String[1]],
  'Bands'        => Optional[Integer[1,16]],
  'StrictBands'  => Optional[Integer[1,16]],
  'QuantumBytes' => Optional[String[1]],
  'PriorityMap'  => Optional[String[1]],
}]
