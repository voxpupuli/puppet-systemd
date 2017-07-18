# **NOTE: THIS IS A [PRIVATE](https://github.com/puppetlabs/puppetlabs-stdlib#assert_private) CLASS**
#
# This class provides an abstract way to trigger resolved
#
# @param ensure
#   The state that the ``networkd`` service should be in
#
class systemd::networkd (
  Enum['stopped','running'] $ensure = 'running',
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
