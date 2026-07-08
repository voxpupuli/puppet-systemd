# @summary interface network IPv6SendRA section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Ipv6sendra = Struct[{
    'Managed'              => Optional[Enum['yes','no']],
    'OtherInformation'     => Optional[Enum['yes','no']],
    'RouterLifetimeSec'    => Optional[Systemd::Timespan],
    'ReachableTimeSec'     => Optional[Systemd::Timespan],
    'RetransmitSec'        => Optional[Systemd::Timespan],
    'RouterPreference'     => Optional[Enum['high', 'medium', 'low', 'normal', 'default']],
    'HopLimit'             => Optional[Integer[0,255]],
    'UplinkInterface'      => Optional[String[1]],
    'EmitDNS'              => Optional[Enum['yes','no']],
    'DNS'                  => Optional[String[1]],
    'EmitDomains'          => Optional[Enum['yes','no']],
    'Domains'              => Optional[String[1]],
    'DNSLifetimeSec'       => Optional[Systemd::Timespan],
    'HomeAgent'            => Optional[Enum['yes','no']],
    'HomeAgentLifetimeSec' => Optional[Systemd::Timespan],
    'HomeAgentPreference'  => Optional[Integer[0,65535]],
}]
