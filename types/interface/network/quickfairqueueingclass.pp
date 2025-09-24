# @summary interface network QuickFairQueueingClass section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Quickfairqueueingclass= Struct[
  {
    'Parent'         => Optional[Variant[Enum['root'], String[1]]],
    'ClassId'        => Optional[String[1]],
    'Weight'         => Optional[Integer[1,1023]],
    'MaxPacketBytes' => Optional[String[1]],
  }
]
