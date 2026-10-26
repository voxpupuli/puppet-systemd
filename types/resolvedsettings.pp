# @summary Configurations for resolved.conf
# @see https://www.freedesktop.org/software/systemd/man/resolved.conf.html
#
type Systemd::ResolvedSettings = Struct[
  {
    Optional['DNS']                => Variant[String, Array[String], Systemd::ResolvedSettings::Ensure],
    Optional['FallbackDNS']        => Variant[String, Array[String], Systemd::ResolvedSettings::Ensure],
    Optional['Domains']            => Variant[String, Array[String], Systemd::ResolvedSettings::Ensure],
    Optional['DNSSEC']             => Variant[Systemd::Boolean, Enum['allow-downgrade'], Systemd::ResolvedSettings::Ensure],
    Optional['DNSOverTLS']         => Variant[Systemd::Boolean, Enum['opportunistic'], Systemd::ResolvedSettings::Ensure],
    Optional['LLMNR']              => Variant[Systemd::Boolean, Enum['resolve'], Systemd::ResolvedSettings::Ensure],
    Optional['MulticastDNS']       => Variant[Systemd::Boolean, Enum['resolve'], Systemd::ResolvedSettings::Ensure],
    Optional['Cache']                   => Variant[Systemd::Boolean, Enum['no-negative'], Systemd::ResolvedSettings::Ensure],
    Optional['CacheFromLocalhost']      => Variant[Systemd::Boolean, Systemd::ResolvedSettings::Ensure],
    Optional['DNSCacheSize']            => Variant[Integer[0, 16777216], Systemd::ResolvedSettings::Ensure],
    Optional['MulticastDNSCacheSize']   => Variant[Integer[0, 16777216], Systemd::ResolvedSettings::Ensure],
    Optional['LLMNRCacheSize']          => Variant[Integer[0, 16777216], Systemd::ResolvedSettings::Ensure],
    Optional['ReadEtcHosts']            => Variant[Systemd::Boolean, Systemd::ResolvedSettings::Ensure],
    Optional['ReadStaticRecords']       => Variant[Systemd::Boolean, Systemd::ResolvedSettings::Ensure],
    Optional['ResolveUnicastSingleLabel'] => Variant[Systemd::Boolean, Systemd::ResolvedSettings::Ensure],
    Optional['RefuseRecordTypes']       => Variant[String, Array[String], Systemd::ResolvedSettings::Ensure],
    Optional['StaleRetentionSec']       => Variant[Systemd::Timespan, Systemd::ResolvedSettings::Ensure],
    Optional['DNSStubListener']         => Variant[Systemd::Boolean, Enum['udp', 'tcp', 'absent'], Systemd::ResolvedSettings::Ensure],
    Optional['DNSStubListenerExtra']    => Variant[String, Array[String[1]], Enum['absent'], Systemd::ResolvedSettings::Ensure],
  }
]
