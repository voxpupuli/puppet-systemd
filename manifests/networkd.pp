# @api private
#
# This class provides an abstract way to trigger systemd-networkd
#
# @param ensure
#   The state that the ``networkd`` service should be in
#
class systemd::networkd (
  Enum['stopped','running'] $ensure = $systemd::networkd_ensure,
){

  assert_private()

  $_enable_networkd = $ensure ? {
    'stopped' => false,
    'running' => true,
    default   => $ensure,
  }

  service{ 'systemd-networkd':
    ensure => $ensure,
    enable => $_enable_networkd,
  }
}
