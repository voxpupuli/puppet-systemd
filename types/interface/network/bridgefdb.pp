# @summary interface network BridgeFDB section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Bridgefdb = Struct[{
  'MACAddress'        => String[1],
  'Destination'       => Optional[String[1]],
  'VLANId'            => Optional[String[1]],
  'VNI'               => Optional[Integer[1, 16777215]],
  'AssociatedWith'    => Optional[Enum['use', 'self', 'master', 'router']],
  'OutgoingInterface' => Optional[String[1]],
}]
