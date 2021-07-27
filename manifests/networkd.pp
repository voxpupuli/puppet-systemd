# @api private
#
# @summary This class provides an abstract way to trigger systemd-networkd
#
# @param ensure The state that the ``networkd`` service should be in
# @param path path where all networkd files are placed in
# @param manage_all_network_files if enabled, all networkd files that aren't managed by puppet will be purged
class systemd::networkd (
  Enum['stopped','running'] $ensure = $systemd::networkd_ensure,
  Stdlib::Absolutepath $path = $systemd::network_path,
  Boolean $manage_all_network_files = $systemd::manage_all_network_files,
) {
  assert_private()

  $_enable_networkd = $ensure ? {
    'stopped' => false,
    'running' => true,
    default   => $ensure,
  }

  service { 'systemd-networkd':
    ensure => $ensure,
    enable => $_enable_networkd,
  }
  # this directory is created by systemd
  # we define it here to purge non-managed files
  if $manage_all_network_files {
    file { $path:
      ensure  => 'directory',
      recurse => true,
      purge   => true,
      notify  => Service['systemd-networkd'],
    }
  }
}
