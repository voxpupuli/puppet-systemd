# **NOTE: THIS IS A [PRIVATE](https://github.com/puppetlabs/puppetlabs-stdlib#assert_private) CLASS**
#
# This class provides an abstract way to trigger resolved
#
# @param ensure
#   The state that the ``resolved`` service should be in
#
class systemd::resolved (
  Enum['stopped','running'] $ensure = $systemd::resolved_ensure,
){

  assert_private()

  $_enable_resolved = $ensure ? {
    'stopped' => false,
    'running' => true,
    default   => $ensure,
  }

  service { 'systemd-resolved':
    ensure => $ensure,
    enable => $_enable_resolved,
  }

  file { '/etc/resolv.conf':
    ensure  => 'symlink',
    target  => '/run/systemd/resolve/resolv.conf',
    require => Service['systemd-resolved'],
  }
}
