# @summary interface network RoutingPolicyRule section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Routingpolicyrule = Struct[
  {
    'TypeOfService'          => Optional[Integer[0,255]],
    'From'                   => Optional[String[1]],
    'To'                     => Optional[String[1]],
    'FirewallMark'           => Optional[Variant[String[1],Integer[1, 4294967295]]],
    'Table'                  => Optional[Variant[Enum['default','main','local'],Integer[1,4294967295],String[1]]],
    'Priority'               => Optional[Integer[0,4294967295]],
    'IncomingInterface'      => Optional[String[1]],
    'OutgoingInterface'      => Optional[String[1]],
    'L3MasterDevice'         => Optional[Enum['yes','no']],
    'SourcePort'             => Optional[String[1]],
    'DestinationPort'        => Optional[String[1]],
    'IPProtocol'             => Optional[String[1]],
    'InvertRule'             => Optional[Enum['yes','no']],
    'Family'                 => Optional[Enum['ipv4', 'ipv6', 'both']],
    'User'                   => Optional[String[1]],
    'SuppressPrefixLength'   => Optional[Integer[0,128]],
    'SuppressInterfaceGroup' => Optional[Integer[0,2147483647]],
    'Type'                   => Optional[Enum['blackhole','unreachable','prohibit']],
  }
]
