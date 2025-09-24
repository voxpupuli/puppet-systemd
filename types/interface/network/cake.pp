# @summary interface network CAKE section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Cake = Struct[{
  'Parent'                 => Optional[Variant[Enum['root', 'clsact', 'ingress'], String[1]]],
  'Bandwidth'              => Optional[String[1]],
  'AutoRateIngress'        => Optional[Enum['yes','no']],
  'OverheadBytes'          => Optional[Integer[-64,256]],
  'MPUBytes'               => Optional[Integer[1,256]],
  'CompensationMode'       => Optional[Enum['none', 'atm', 'ptm']],
  'UseRawPacketSize'       => Optional[Enum['yes','no']],
  'FlowIsolationMode'      => Optional[Enum['none','src-host', 'dst-host', 'hosts', 'flows','dual-src-host', 'dual-dst-host', 'triple']],
  'NAT'                    => Optional[Enum['yes','no']],
  'PriorityQueueingPreset' => Optional[Enum['besteffort','precedence', 'diffserv8', 'diffserv4', 'diffserv3']],
  'FirewallMark'           => Optional[Integer[1,4294967295]],
  'Wash'                   => Optional[Enum['yes','no']],
  'SplitGSO'               => Optional[Enum['yes','no']],
  'RTTSec'                 => Optional[String[1]],
  'AckFilter'              => Optional[Enum['yes','no']],
}]
