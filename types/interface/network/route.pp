# @summary interface network Route section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Route = Struct[
  {
    'Gateway'                            => Optional[Variant[Array[String[1]], String[1]]],
    'GatewayOnLink'                      => Optional[Enum['yes', 'no']],
    'Destination'                        => Optional[String[1]],
    'Source'                             => Optional[String[1]],
    'Metric'                             => Optional[Integer[0,4294967295]],
    'IPv6Preference'                     => Optional[Enum['low','medium', 'high']],
    'Scope'                              => Optional[Enum['global', 'site', 'link', 'host', 'nowhere']],
    'PreferredSource'                    => Optional[String[1]],
    'Table'                              => Optional[Variant[String[1], Enum['default','main', 'local'], Integer[1,4294967295]]],
    'HopLimit'                           => Optional[Integer[1,255]],
    'Protocol'                           => Optional[Variant[Integer[0,255], Enum['kernel', 'boot', 'static', 'ra', 'dhcp']]],
    'Type'                               => Optional[Enum[
        'unicast', 'local', 'broadcast', 'anycast', 'multicast',
        'blackhole', 'unreachable', 'prohibit', 'throw', 'nat', 'xresolve'
      ]
    ],
    'InitialCongestionWindow'            => Optional[Integer[0,1023]],
    'InitialAdvertisedReceiveWindow'     => Optional[Integer[0,1023]],
    'QuickAck'                           => Optional[Enum['yes', 'no',]],
    'FastOpenNoCookie'                   => Optional[Enum['yes', 'no',]],
    'MTUBytes'                           => Optional[String[1]],
    'TCPAdvertisedMaximumSegmentSize'    => Optional[String[1]],
    'TCPCongestionControlAlgorithm'      => Optional[Enum['bbr', 'dctcp', 'vegas']],
    'TCPRetransmissionTimeoutSeca'       => Optional[Integer[1]],
    'MultiPathRoute'                     => Optional[Variant[String[1],Array[String[1]]]],
    'NextHop'                            => Optional[Integer[1, 4294967295]],
  }
]
