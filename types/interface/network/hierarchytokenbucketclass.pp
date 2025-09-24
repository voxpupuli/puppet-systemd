# @summary interface network HierarchyTokenBucketClass section definition
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
type Systemd::Interface::Network::Hierarchytokenbucketclass = Struct[{
  'Parent'          => Optional[Variant[Enum['root'], String[1]]],
  'ClassId'         => Optional[String[1]],
  'Priority'        => Optional[String[1]],
  'QuantumBytes'    => Optional[String[1]],
  'MTUBytes'        => Optional[String[1]],
  'OverheadBytes'   => Optional[String[1]],
  'Rate'            => Optional[String[1]],
  'CeilRate'        => Optional[String[1]],
  'BufferBytes'     => Optional[String[1]],
  'CeilBufferBytes' => Optional[String[1]],
}]
