# @summary Possible keys for the [Slice] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.slice.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
#
type Systemd::Unit::Slice = Struct[
  {
    # Options from systemd.slice
    # https://www.freedesktop.org/software/systemd/man/systemd.slice.html
    #
    # Options from systemd.resource-control
    # https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html
    Optional['AllowedCPUs']         => Pattern[/^\d+(-\d+)?(,\d+(-\d+)?)*$/],
    Optional['CPUQuota']            => Optional[Pattern['^([1-9][0-9]*)%$']], # bigger than 100% is okay.
    Optional['CPUWeight']           => Variant[Enum['idle'],Integer[1,10000]],
    Optional['DeviceAllow']         => Pattern['^(/dev/)|(char-)|(block-).*$'],
    Optional['DevicePolicy']        => Enum['auto','closed','strict'],
    Optional['Delegate']            => Boolean,
    Optional['IOAccounting']        => Boolean,
    Optional['IODeviceWeight']      => Variant[Tuple[Stdlib::Absolutepath, Integer[1,10000]],Array[Tuple[Stdlib::Absolutepath, Integer[1,10000]]]],
    Optional['IOReadBandwidthMax']  => Variant[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount],Array[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount]]],
    Optional['IOReadIOPSMax']       => Variant[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount],Array[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount]]],
    Optional['IOWeight']            => Integer[1,10000],
    Optional['IOWriteBandwidthMax'] => Variant[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount],Array[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount]]],
    Optional['IOWriteIOPSMax']      => Variant[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount],Array[Tuple[Stdlib::Absolutepath, Systemd::Unit::Amount]]],
    Optional['IPAccounting']        => Boolean,
    Optional['IPAddressAllow']      => Variant[Enum['any','localhost','link-local','multicast'],Array[Variant[Stdlib::IP::Address, Stdlib::IP::Address::CIDR]]],
    Optional['IPAddressDeny']       => Variant[Enum['any','localhost','link-local','multicast'],Array[Variant[Stdlib::IP::Address, Stdlib::IP::Address::CIDR]]],
    Optional['MemoryAccounting']    => Boolean,
    Optional['MemoryHigh']          => Systemd::Unit::AmountOrPercent,
    Optional['MemoryLow']           => Systemd::Unit::AmountOrPercent,
    Optional['MemoryMax']           => Systemd::Unit::AmountOrPercent,
    Optional['MemoryMin']           => Systemd::Unit::AmountOrPercent,
    Optional['MemorySwapMax']       => Systemd::Unit::AmountOrPercent,
    Optional['Slice']               => String[1],
    Optional['StartupIOWeight']     => Integer[1,10000],
    Optional['TasksAccounting']     => Boolean,
    Optional['TasksMax']            => Systemd::Unit::AmountOrPercent,
    # Deprecated options
    Optional['CPUAccounting']       => Boolean,
    Optional['CPUShares']           => Integer[2,262144],
    Optional['MemoryLimit']         => Systemd::Unit::AmountOrPercent,
    Optional['StartupCPUShares']    => Integer[2,262144],
  }
]
