# Activate the modules contained in modules-loads.d
#
# @api private
#
# @see systemd-modules-load.service(8)
#
class systemd::modules_loads {
  exec { 'systemd-modules-load' :
    command     => 'systemctl start systemd-modules-load.service',
    refreshonly => true,
    path        => $facts['path'],
  }
}
