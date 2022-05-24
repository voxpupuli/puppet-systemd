# Matches Systemd machine-info (hostnamectl) file Struct
type Systemd::MachineInfoSettings = Struct[
  {
    Optional['PRETTY_HOSTNAME'] => String[1],
    Optional['ICON_NAME']       => String[1],
    Optional['CHASSIS']         => String[1],
    Optional['DEPLOYMENT']      => String[1],
    Optional['LOCATION']        => String[1],
    Optional['HARDWARE_VENDOR'] => String[1],
    Optional['HARDWARE_MODEL']  => String[1],
  }
]
