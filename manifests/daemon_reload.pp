# -- Class: systemd::daemon_reload
# Triggers systemd to reload unit files
class systemd::daemon_reload {
  exec { 'systemctl-daemon-reload':
    command     => 'systemctl daemon-reload',
    refreshonly => true,
    path        => $::path,
  }
}