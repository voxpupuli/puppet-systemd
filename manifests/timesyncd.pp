# **NOTE: THIS IS A [PRIVATE](https://github.com/puppetlabs/puppetlabs-stdlib#assert_private) CLASS**
#
# This class provides an abstract way to trigger systemd-timesyncd
#
# @param ensure
#   The state that the ``networkd`` service should be in
#
class systemd::timesyncd (
  Enum['stopped','running'] $ensure = 'running',
){

  assert_private()

  $_enable_timesyncd = $ensure ? {
    'stopped' => false,
    'running' => true,
    default   => $ensure,
  }

  service{ 'systemd-timesyncd':
    ensure => $ensure,
    enable => $_enable_timesyncd,
  }
}
