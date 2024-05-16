# Deprecated - Adds a set of custom limits to the service
#
# @api public
#
# @see systemd.exec(5)
#
# @param name [Pattern['^.+\.(service|socket|mount|swap)$']]
#   The name of the service that you will be modifying
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
# @param limits
#   A Hash of service limits matching the settings in ``systemd.exec(5)``
#
#   * Mutually exclusive with ``$source``
#
# @param source
#   A ``File`` resource compatible ``source``
#
#   * Mutually exclusive with ``$limits``
#
# @param restart_service
#   Unused parameter for compatibility with older versions. Will fail if true is passed in.
#
define systemd::service_limits (
  Enum['present', 'absent', 'file'] $ensure                  = 'present',
  Stdlib::Absolutepath              $path                    = '/etc/systemd/system',
  Boolean                           $selinux_ignore_defaults = false,
  Optional[Systemd::ServiceLimits]  $limits                  = undef,
  Optional[String]                  $source                  = undef,
  Boolean                           $restart_service         = false,
) {
  if $restart_service {
    fail('The restart_service parameter is deprecated and only false is a valid value')
  }

  include systemd

  if $name !~ Pattern['^.+\.(service|socket|mount|swap)$'] {
    fail('$name must match Pattern["^.+\.(service|socket|mount|swap)$"]')
  }

  if $ensure != 'absent' {
    if ($limits and !empty($limits)) and $source {
      fail('You may not supply both limits and source parameters to systemd::service_limits')
    }
    elsif ($limits == undef or empty($limits)) and ($source == undef) {
      fail('You must supply either the limits or source parameter to systemd::service_limits')
    }
  }

  if $limits {
    # Some typing changed between Systemd::ServiceLimits and Systemd::Unit::Service
    $_now_tupled = [
      'IODeviceWeight',
      'IOReadBandwidthMax',
      'IOWriteBandwidthMax',
      'IOReadIOPSMax',
      'IOWriteIOPSMax',
    ]

    $_my_limits = $limits.map | $_directive, $_value | {
      if $_directive in $_now_tupled {
        { $_directive => $_value.map | $_pair | { Array($_pair).flatten } }  # Convert { 'a' => 'b' } to ['a', b']
      } else {
        { $_directive => $_value }
      }
    }.reduce | $_memo, $_value | { $_memo + $_value }

    deprecation("systemd::service_limits - ${title}",'systemd::service_limits is deprecated, use systemd::manage_dropin')
    systemd::manage_dropin { "${name}-90-limits.conf":
      ensure                  => $ensure,
      unit                    => $name,
      filename                => '90-limits.conf',
      path                    => $path,
      selinux_ignore_defaults => $selinux_ignore_defaults,
      service_entry           => $_my_limits,
      notify_service          => true,
    }
  } else {
    deprecation("systemd::service_limits ${title}",'systemd::service_limits is deprecated, use systemd::dropin_file or systemd::manage_dropin')
    systemd::dropin_file { "${name}-90-limits.conf":
      ensure                  => $ensure,
      unit                    => $name,
      filename                => '90-limits.conf',
      path                    => $path,
      selinux_ignore_defaults => $selinux_ignore_defaults,
      source                  => $source,
      notify_service          => true,
    }
  }
}
