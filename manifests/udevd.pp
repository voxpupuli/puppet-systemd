# @api private
# @summary This class manages systemd's udev config
# @see https://www.freedesktop.org/software/systemd/man/udev.conf.html
class systemd::udevd {
  assert_private()

  service { 'systemd-udevd':
    ensure => running,
    enable => true,
  }

  file { '/etc/udev/rules.d':
    ensure  => directory,
    purge   => $systemd::udev_purge_rules,
    recurse => true,
  }

  file { '/etc/udev/udev.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => epp("${module_name}/udev_conf.epp", {
        'udev_log'            => $systemd::udev_log,
        'udev_children_max'   => $systemd::udev_children_max,
        'udev_exec_delay'     => $systemd::udev_exec_delay,
        'udev_event_timeout'  => $systemd::udev_event_timeout,
        'udev_resolve_names'  => $systemd::udev_resolve_names,
        'udev_timeout_signal' => $systemd::udev_timeout_signal,
    }),
    notify  => Service['systemd-udevd'],
  }

  $systemd::udev_rules.each |$udev_rule_name, $udev_rule| {
    systemd::udev::rule { $udev_rule_name:
      * => $udev_rule,
    }
  }

  exec { 'systemd-udev_reload':
    command     => 'udevadm control --reload-rules && udevadm trigger',
    refreshonly => true,
    path        => $facts['path'],
  }
}
