# @summary Defines systemd boolean "true" type representation
type Systemd::Boolean::True = Variant[Integer[1], Enum['yes', 'true'], Boolean[true]]
