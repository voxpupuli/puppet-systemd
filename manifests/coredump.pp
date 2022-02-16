# @api private
# @summary This class manages the systemd-coredump configuration.
# @see https://www.freedesktop.org/software/systemd/man/systemd-coredump.html
class systemd::coredump {
  assert_private()

  $systemd::coredump_settings.each |$option, $value| {
    ini_setting {
      "coredump_${option}":
        path    => '/etc/systemd/coredump.conf',
        section => 'Coredump',
        setting => $option,
        value   => $value,
    }
  }

  systemd::dropin_file { 'coredump_backtrace.conf':
    ensure  => bool2str($systemd::coredump_backtrace, 'file', 'absent'),
    unit    => 'systemd-coredump@.service',
    content => "# Puppet\n[Service]\nExecStart=\nExecStart=-/usr/lib/systemd/systemd-coredump --backtrace\n",
  }
}
