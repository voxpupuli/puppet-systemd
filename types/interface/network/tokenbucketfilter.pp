# @summary interface network TokenBucketFilter section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Tokenbucketfilter = Struct[
  {
    'Parent'     => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
    'Handle'     => Optional[String[1]],
    'LatencySec' => Optional[String[1]],
    'LimitBytes' => Optional[String[1]],
    'BurstBytes' => Optional[String[1]],
    'Rate'       => Optional[String[1]],
    'MPUBytes'   => Optional[String[1]],
    'PeakRate'   => Optional[String[1]],
    'MTUBytes'   => Optional[String[1]],
  }
]
