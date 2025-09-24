# @summary netdev BatmanAdvanced section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Batmanadvanced = Struct[{
  'GatewayMode'           => Optional[Enum['off', 'server', 'client']],
  'Aggregation'           => Optional[Enum['yes','no']],
  'BridgeLoopAvoidance'   => Optional[Enum['yes','no']],
  'DistributedArpTable'   => Optional[Enum['yes','no']],
  'Fragmentation'         => Optional[Enum['yes','no']],
  'HopPenalty'            => Optional[Integer[0,255]],
  'OriginatorIntervalSec' => Optional[String[1]],
  'GatewayBandwidthDown'  => Optional[String[1]],
  'GatewayBandwidthUp'    => Optional[String[1]],
  'RoutingAlgorithm'      => Optional[Enum['batman-v', 'batman-iv']],
}]
