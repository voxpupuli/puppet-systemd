# @summary netdev Bond section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Bond = Struct[{
  'Mode'                         => Optional[Enum[
    'balance-rr', 'active-backup', 'balance-xor',
    'broadcast', '802.3ad', 'balance-tlb', 'balance-alb'
  ]],
  'TransmitHashPolicy'           => Optional[Enum['layer2', 'layer3+4', 'layer2+3', 'encap2+3', 'encap3+4']],
  'LACPTransmitRate'             => Optional[Enum['slow','fast']],
  'MIIMonitorSec'                => Optional[Integer],
  'PeerNotifyDelaySec'           => Optional[Integer[0,300]],
  'UpDelaySec'                   => Optional[Integer[0]],
  'DownDelaySec'                 => Optional[Integer[0]],
  'LearnPacketIntervalSec'       => Optional[Integer[1]],
  'AdSelect'                     => Optional[Enum['stable', 'bandwidth', 'count']],
  'AdActorSystemPriority'        => Optional[Integer[1,65535]],
  'AdUserPortKey'                => Optional[Integer[1,1023]],
  'AdActorSystem'                => Optional[String[1]],
  'FailOverMACPolicy'            => Optional[Enum['none', 'active', 'follow']],
  'ARPValidate'                  => Optional[Enum['none', 'active', 'backup', 'all']],
  'ARPIntervalSec'               => Optional[String[1]],
  'ARPIPTargets'                 => Optional[String[1]],
  'ARPAllTargets'                => Optional[Enum['any','all']],
  'PrimaryReselectPolicy'        => Optional[Enum['alwayas', 'better', 'failure']],
  'ResendIGMP'                   => Optional[Integer[0,255]],
  'PacketsPerSlave'              => Optional[Integer[0,65535]],
  'GratuitousARP'                => Optional[Integer[0,255]],
  'AllSlavesActive'              => Optional[Enum['yes','no']],
  'DynamicTransmitLoadBalancing' => Optional[Enum['yes','no']],
  'MinLinks'                     => Optional[Integer],
  'ARPMissedMax'                 => Optional[Integer],
}]
