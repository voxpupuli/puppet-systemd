# @summary Configurations for timesyncd.conf
# @see https://www.freedesktop.org/software/systemd/man/timesyncd.conf.html
#
type Systemd::TimesyncdSettings = Struct[
  {
    Optional['NTP']                => Variant[String, Array[String], Systemd::TimesyncdSettings::Ensure],
    Optional['FallbackNTP']        => Variant[String, Array[String], Systemd::TimesyncdSettings::Ensure],
    Optional['RootDistanceMaxSec'] => Variant[Systemd::Timespan, Systemd::TimesyncdSettings::Ensure],
    Optional['PollIntervalMinSec'] => Variant[Systemd::Timespan, Systemd::TimesyncdSettings::Ensure],
    Optional['PollIntervalMaxSec'] => Variant[Systemd::Timespan, Systemd::TimesyncdSettings::Ensure],
    Optional['ConnectionRetrySec'] => Variant[Systemd::Timespan, Systemd::TimesyncdSettings::Ensure],
    Optional['SaveIntervalSec']    => Variant[Systemd::Timespan, Systemd::TimesyncdSettings::Ensure],
  }
]
