# @summary Possible keys for the [Unit] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.unit.html
#
type Systemd::Unit::Unit = Struct[
  {
    Optional['Description']              => Variant[String,Array[String,1]],
    Optional['Documentation']            => Variant[String,Array[String,1]],
    Optional['Wants']                    => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['Requires']                 => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['Requisite']                => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['PartOf']                   => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['Upholds']                  => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['Conflicts']                => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['Before']                   => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['After']                    => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['OnFailure']                => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    Optional['OnSuccess']                => Variant[Enum[''],Systemd::Unit,Array[Variant[Enum[''],Systemd::Unit],1]],
    # Conditions and Asserts
    Optional['ConditionPathExists']      => Variant[Enum[''],Stdlib::Unixpath,Pattern[/^!.*$/],Array[Variant[Enum[''],Stdlib::Unixpath,Pattern[/^!.*$/]],1]],
    Optional['ConditionPathIsDirectory'] => Variant[Enum[''],Stdlib::Unixpath,Pattern[/^!.*$/],Array[Variant[Enum[''],Stdlib::Unixpath,Pattern[/^!.*$/]],1]],
    Optional['AssertPathExists']         => Variant[Enum[''],Stdlib::Unixpath,Pattern[/^!.*$/],Array[Variant[Enum[''],Stdlib::Unixpath,Pattern[/^!.*$/]],1]],
    Optional['AssertPathIsDirectory']    => Variant[Enum[''],Stdlib::Unixpath,Pattern[/^!.*$/],Array[Variant[Enum[''],Stdlib::Unixpath,Pattern[/^!.*$/]],1]],
  }
]
