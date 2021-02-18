# Reload the systemctl daemon
#
# @api public
define systemd::systemctl::daemon_reload {
  exec { "systemctl-daemon-reload # ${title}":
    command     => "systemctl daemon-reload # ${title}",
    refreshonly => true,
    path        => $facts['path'],
  }
}
