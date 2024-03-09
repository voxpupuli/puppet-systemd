# @summary Possible keys for the [Slice] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.slice.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
#
type Systemd::Unit::Slice = Struct[
  {
    Optional['CPUAccounting']       => Boolean,
    Optional['CPUQuota']            => Pattern['^([1-9][0-9]*)%$'], # bigger than 100% is okay.
    Optional['CPUShares']           => Integer[2,262144],
    Optional['CPUWeight']           => Variant[Enum['idle'],Integer[1,10000]],
    Optional['Delegate']            => Boolean,
    Optional['DeviceAllow']         => Pattern['^(/dev/)|(char-)|(block-).*$'],
    Optional['DevicePolicy']        => Enum['auto','closed','strict'],
    Optional['IOAccounting']        => Boolean,
    Optional['IODeviceWeight']      => Variant[Tuple[Stdlib::Absolutepath, Integer[1,10000]],Array[Tuple[Stdlib::Absolutepath, Integer[1,10000]]]],
    Optional['IOReadBandwidthMax']  => Variant[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount],Array[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount]]],
    Optional['IOReadIOPSMax']       => Variant[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount],Array[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount]]],
    Optional['IOWeight']            => Integer[1,10000],
    Optional['IOWriteBandwidthMax'] => Variant[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount],Array[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount]]],
    Optional['IOWriteIOPSMax']      => Variant[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount],Array[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount]]],
    Optional['IPAccounting']        => Boolean,
    Optional['MemoryAccounting']    => Boolean,
    Optional['MemoryHigh']          => Systemd::Unit::AmountOrPercent,
    Optional['MemoryLimit']         => Systemd::Unit::AmountOrPercent, # depprecated in systemd
    Optional['MemoryLow']           => Systemd::Unit::AmountOrPercent,
    Optional['MemoryMax']           => Systemd::Unit::AmountOrPercent,
    Optional['MemoryMin']           => Systemd::Unit::AmountOrPercent,
    Optional['MemorySwapMax']       => Systemd::Unit::AmountOrPercent,
    Optional['Slice']               => String[1],
    Optional['StartupCPUShares']    => Integer[2,262144],
    Optional['StartupIOWeight']     => Integer[1,10000],
    Optional['TasksAccounting']     => Boolean,
    Optional['TasksMax']            => Systemd::Unit::AmountOrPercent,
  }
]
