# @summary Possible keys for the [Mount] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.mount.html
#
type Systemd::Unit::Mount = Struct[
  {
    Optional['What']          => String[1],
    Optional['Where']         => Stdlib::Unixpath,
    Optional['Type']          => String[1],
    Optional['Options']       => String[1],
    Optional['SloppyOptions'] => Boolean,
    Optional['LazyUnmount']   => Boolean,
    Optional['ReadWriteOnly'] => Boolean,
    Optional['ForceUnmount']  => Boolean,
    Optional['DirectoryMode'] => Stdlib::Filemode,
    Optional['TimeoutSec']    => String[0],
  }
]
