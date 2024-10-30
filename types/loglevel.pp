# @summary Defines allowed log levels
type Systemd::LogLevel = Variant[Enum['emerg','alert','crit','err','warning','notice','info','debug'], Integer[0,7]]
