# -- Define: systemd::simplified_unit_file
# Create simplified unit file for systemd
define systemd::simplified_unit_file (
  $source_base,
){
  ::systemd::unit_file { $name:
    source => "${source_base}/${name}",
  }
}

