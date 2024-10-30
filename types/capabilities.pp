# @summary Defines allowed capabilities
type Systemd::Capabilities = Variant[Pattern[/^~?(CAP_[A-Z_]+ *)+$/]]
