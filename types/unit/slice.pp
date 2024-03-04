# @summary Possible keys for the [Slice] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.slice.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
#
type Systemd::Unit::Slice = Struct[
  {
    Optional['CPUAccounting']       => Boolean,
    Optional['CPUQuota']            => Pattern['^([1-9][0-9]*)%$'],
    Optional['CPUShares']           => Integer[2,262144],
    Optional['CPUWeight']           => Variant[Enum['idle'],Integer[1,10000]],
    Optional['Delegate']            => Boolean,
    Optional['DeviceAllow']         => String[1],
    Optional['DevicePolicy']        => Enum['auto','closed','strict'],
    Optional['IOAccounting']        => Boolean,
    Optional['IODeviceWeight']      => Array[Hash[Stdlib::Absolutepath, Integer[1,10000], 1, 1]],
    Optional['IOReadBandwidthMax']  => Array[Hash[Stdlib::Absolutepath, Pattern['^(\d+(K|M|G|T)?)$'], 1, 1]],
    Optional['IOReadIOPSMax']       => Array[Hash[Stdlib::Absolutepath, Pattern['^(\d+(K|M|G|T)?)$'], 1, 1]],
    Optional['IOWeight']            => Integer[1,10000],
    Optional['IOWriteBandwidthMax'] => Array[Hash[Stdlib::Absolutepath, Pattern['^(\d+(K|M|G|T)?)$'], 1, 1]],
    Optional['IOWriteIOPSMax']      => Array[Hash[Stdlib::Absolutepath, Pattern['^(\d+(K|M|G|T)?)$'], 1, 1]],
    Optional['IPAccounting']        => Boolean,
    Optional['MemoryAccounting']    => Boolean,
    Optional['MemoryHigh']          => Pattern['\A(infinity|\d+(K|M|G|T|%)?(:\d+(K|M|G|T|%)?)?)\z'],
    Optional['MemoryLimit']         => Pattern['\A(infinity|\d+(K|M|G|T|%)?(:\d+(K|M|G|T|%)?)?)\z'], # dep'd in systemd
    Optional['MemoryLow']           => Pattern['\A(infinity|\d+(K|M|G|T|%)?(:\d+(K|M|G|T|%)?)?)\z'],
    Optional['MemoryMax']           => Pattern['\A(infinity|\d+(K|M|G|T|%)?(:\d+(K|M|G|T|%)?)?)\z'],
    Optional['MemoryMin']           => Pattern['\A(infinity|\d+(K|M|G|T|%)?(:\d+(K|M|G|T|%)?)?)\z'],
    Optional['MemorySwapMax']       => Pattern['\A(infinity|\d+(K|M|G|T|%)?(:\d+(K|M|G|T|%)?)?)\z'],
    Optional['Slice']               => String[1],
    Optional['StartupCPUShares']    => Integer[2,262144],
    Optional['StartupIOWeight']     => Integer[1,10000],
    Optional['TasksAccounting']     => Boolean,
    Optional['TasksMax']            => Variant[Integer[1],Pattern['^(infinity|([1-9][0-9]?$|^100)%)$']],
  }
]
