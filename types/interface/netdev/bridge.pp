# @summary netdev Bridge section
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html
type Systemd::Interface::Netdev::Bridge = Struct[{
  'Description'          => Optional[String[1]],
  'HelloTimeSec'         => Optional[Integer[1]],
  'MaxAgeSec'            => Optional[Integer[1]],
  'ForwardDelaySec'      => Optional[Integer[1]],
  'AgeingTimeSec'        => Optional[Integer[1]],
  'Priority'             => Optional[Integer[0, 65535]],
  'GroupForwardMask'     => Optional[String[1]],
  'DefaultPVID'          => Optional[Variant[Enum['none'],String[1, 4094]]],
  'MulticastQuerier'     => Optional[Enum['yes','no']],
  'MulticastSnooping'    => Optional[Enum['yes','no']],
  'VLANFiltering'        => Optional[Enum['yes','no']],
  'STP'                  => Optional[Enum['yes','no']],
  'MulticastIGMPVersion' => Optional[Integer[2,3]],
}]
