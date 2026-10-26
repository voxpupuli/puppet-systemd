# @summary Value type accepted by the generic config drop-in template.
# This intentionally accepts the union of all value shapes used by the
# component-specific settings types (strings, numbers, booleans, arrays,
# and ensure hashes).
type Systemd::ConfigDropinValue = Variant[
  String,
  Numeric,
  Boolean,
  Array[Variant[String, Numeric, Boolean]],
  Struct[{
    Optional['ensure'] => Enum['present', 'absent'],
    Optional['value']  => Variant[String, Numeric, Boolean, Array[Variant[String, Numeric, Boolean]]],
  }],
]
