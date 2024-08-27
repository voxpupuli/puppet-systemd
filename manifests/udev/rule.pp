# Adds a custom udev rule
#
# @api public
#
# @see udev(7)
#
# @param name [Pattern['^.+\.rules$']]
#   The name of the udev rules to create
#
# @param ensure
#   Whether to drop a file or remove it
#
# @param path
#   The path to the main systemd settings directory
#
# @param selinux_ignore_defaults
#   If Puppet should ignore the default SELinux labels.
#
# @param notify_services
#   List of services to notify when this rule is updated
#
# @param rules
#   The literal udev rules you want to deploy
#
define systemd::udev::rule (
  Array                             $rules                   = [],
  Enum['present', 'absent', 'file'] $ensure                  = 'file',
  Stdlib::Absolutepath              $path                    = '/etc/udev/rules.d',
  Variant[Array[String[1]], String[1]] $notify_services      = [],
  Boolean                           $selinux_ignore_defaults = false,
) {
  include systemd

  $filename = assert_type(Pattern['^.+\.rules$'], $name) |$expected, $actual| {
    fail("The \$name should match \'${expected}\', you passed \'${actual}\'")
  }
  if $ensure in ['file', 'present'] and empty($rules) {
    fail("systemd::udev::rule - ${name}: param rules is empty, you need to pass rules")
  }

  $_notify = if $systemd::udev_reload {
    if $notify_services =~ Array {
      $notify_services << 'Exec[systemd-udev_reload]'
    } else {
      [$notify_services, 'Exec[systemd-udev_reload]']
    }
  } else {
    $notify_services
  }

  file { join([$path, $name], '/'):
    ensure                  => $ensure,
    owner                   => 'root',
    group                   => 'root',
    mode                    => '0444',
    notify                  => $_notify,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    content                 => epp("${module_name}/udev_rule.epp", { 'rules' => $rules }),
  }
}
