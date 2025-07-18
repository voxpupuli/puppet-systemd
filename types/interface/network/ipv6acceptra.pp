# @summary interface network IPv6AcceptRA section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Ipv6acceptra = Struct[{
    'UseRedirect'           => Optional[Enum['yes','no']],
    'Token'                 => Optional[String[1]],
    'UseDNS'                => Optional[Enum['yes','no']],
    'UseDomains'            => Optional[Enum['yes','no']],
    'RouteTable'            => Optional[Variant[String[1],Integer[0,4294967295]]],
    'RouteMetric'           => Optional[String[1]],
    'QuickAck'              => Optional[Enum['yes','no']],
    'UseMTU'                => Optional[Enum['yes','no']],
    'UseHopLimit'           => Optional[Enum['yes','no']],
    'UseReachableTime'      => Optional[Enum['yes','no']],
    'UseRetransmissionTime' => Optional[Enum['yes','no']],
    'UseGateway'            => Optional[Enum['yes','no']],
    'UseRoutePrefix'        => Optional[Enum['yes','no']],
    'UseCaptivePortal'      => Optional[Enum['yes','no']],
    'UsePREF64'             => Optional[Enum['yes','no']],
    'UseAutonomousPrefix'   => Optional[Enum['yes','no']],
    'UseOnLinkPrefix'       => Optional[Enum['yes','no']],
    'RouterDenyList'        => Optional[String[1]],
    'RouterAllowList'       => Optional[String[1]],
    'PrefixDenyList'        => Optional[String[1]],
    'PrefixAllowList'       => Optional[String[1]],
    'RouteDenyList'         => Optional[String[1]],
    'RouteAllowList'        => Optional[String[1]],
    'DHCPv6Client'          => Optional[Enum['yes','no', 'always']],
    'NetLabel'              => Optional[String[1]],
    'NFTSet'                => Optional[String[1]],
}]
