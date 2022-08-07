# @summary Possible keys for the [Install] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.unit.html
#
type Systemd::Unit::Install = Struct[
  {
    Optional['Alias']      => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['WantedBy']   => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['RequiredBy'] => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['Also']       => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
  }
]
