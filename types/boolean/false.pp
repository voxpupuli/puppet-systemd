# @summary Defines systemd boolean "false" type representation
type Systemd::Boolean::False = Variant[Integer[0,0], Enum['no', 'false'], Boolean[false]]
