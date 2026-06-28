# @api private
#
# @summary Reloads udev so that changed `.link` files are applied
#
# `.link` files in the systemd-networkd directory are read by systemd-udevd,
# not by systemd-networkd. They are applied by reloading udev and retriggering
# the net subsystem, so `systemd::network` notifies this exec for `.link` files
# instead of restarting systemd-networkd.
class systemd::network_reload {
  assert_private()
  include systemd

  exec { 'systemd-network-link_reload':
    command     => 'udevadm control --reload && udevadm trigger --subsystem-match=net',
    refreshonly => true,
    path        => $facts['path'],
  }

  # Link-layer changes (interface naming, MTU, ...) must settle before
  # systemd-networkd reconfigures the interfaces that match on them.
  if $systemd::manage_networkd {
    Exec['systemd-network-link_reload'] -> Service['systemd-networkd']
  }
}
