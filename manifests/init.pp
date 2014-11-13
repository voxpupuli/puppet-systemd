class systemd {

  exec { 'systemctl-daemon-reload':
    command     => 'systemctl daemon-reload',
    refreshonly => true,
    path        => $::path,
  }
}
