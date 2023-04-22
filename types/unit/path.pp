# @summary Possible keys for the [Path] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.path.html
#
type Systemd::Unit::Path = Struct[
  {
    Optional['PathExists']              => Variant[Enum[''],Stdlib::Unixpath,Array[Variant[Enum[''],Stdlib::Unixpath],1]],
    Optional['PathExistsGlob']          => Variant[Enum[''],Stdlib::Unixpath,Array[Variant[Enum[''],Stdlib::Unixpath],1]],
    Optional['PathChanged']             => Variant[Enum[''],Stdlib::Unixpath,Array[Variant[Enum[''],Stdlib::Unixpath],1]],
    Optional['PathModified']            => Variant[Enum[''],Stdlib::Unixpath,Array[Variant[Enum[''],Stdlib::Unixpath],1]],
    Optional['DirectoryNotEmpty']       => Variant[Enum[''],Stdlib::Unixpath,Array[Variant[Enum[''],Stdlib::Unixpath],1]],
    Optional['Unit']                    => Systemd::Unit,
    Optional['MakeDirectory']           => Boolean,
    Optional['DirectoryMode']           => Pattern[/\A[0-7]{1,4}\z/],
    Optional['TriggerLimitIntervalSec'] => String,
    Optional['TriggerLimitBurst']       => Integer[0],
  }
]
