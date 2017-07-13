# -- Class systemd
# This module allows triggering systemd commands once for all modules
class systemd (
  $service_limits          = {},
  Boolean $manage_resolved = true,
){

  Exec {
    refreshonly => true,
    path        => $::path,
  }

  exec {
    'systemctl-daemon-reload':
      command => 'systemctl daemon-reload',
  }

  exec {
    'systemd-tmpfiles-create':
      command => 'systemd-tmpfiles --create',
  }

  create_resources('systemd::service_limits', $service_limits, {})

  if $manage_resolved {
    service{'systemd-resolved':
      ensure => 'running',
      enable => true,
    }
    -> file{'/etc/resolv.conf':
      ensure => 'symlink',
      target => '/run/systemd/resolve/resolv.conf',
    }
  }
}
