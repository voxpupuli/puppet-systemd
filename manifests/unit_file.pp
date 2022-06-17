# @summary Creates a systemd unit file
#
# @api public
#
# @see systemd.unit(5)
#
# @param name [Pattern['^[^/]+\.(service|socket|device|mount|automount|swap|target|path|timer|slice|scope)$']]
#   The target unit file to create
#
# @param ensure
#   The state of the unit file to ensure
#
# @param path
#   The main systemd configuration path
#
# @param content
#   The full content of the unit file
#
#   * Mutually exclusive with ``$source``
#
# @param source
#   The ``File`` resource compatible ``source``
#
#   * Mutually exclusive with ``$content``
#
# @param target
#   If set, will force the file to be a symlink to the given target
#
#   * Mutually exclusive with both ``$source`` and ``$content``
#
# @param owner
#   The owner to set on the unit file
#
# @param group
#   The group to set on the unit file
#
# @param mode
#   The mode to set on the unit file
#
# @param show_diff
#   Whether to show the diff when updating unit file
#
# @param enable
#   If set, will manage the unit enablement status.
#
# @param active
#   If set, will manage the state of the unit.
#
# @param restart
#   Specify a restart command manually. If left unspecified, a standard Puppet service restart happens.
#
# @param hasrestart
#   maps to the same param on the service resource. Optional in the module because it's optional in the service resource type. This param is deprecated. Set it via $service_parameters.
#
# @param hasstatus
#   maps to the same param on the service resource. true in the module because it's true in the service resource type. This param is deprecated. Set it via $service_parameters.
#
# @param selinux_ignore_defaults
#   maps to the same param on the file resource for the unit. false in the module because it's false in the file resource type
#
# @param service_parameters
#   hash that will be passed with the splat operator to the service resource
#
# @param daemon_reload
#   call `systemd::daemon-reload` to ensure that the modified unit file is loaded
#
# @example manage unit file + service
#   systemd::unit_file { 'foo.service':
#     content => file("${module_name}/foo.service"),
#     enable  => true,
#     active  => true,
#   }
#
define systemd::unit_file (
  Enum['present', 'absent', 'file']        $ensure    = 'present',
  Stdlib::Absolutepath                     $path      = '/etc/systemd/system',
  Optional[Variant[String, Sensitive[String], Deferred]] $content = undef,
  Optional[String]                         $source    = undef,
  Optional[Stdlib::Absolutepath]           $target    = undef,
  String                                   $owner     = 'root',
  String                                   $group     = 'root',
  String                                   $mode      = '0444',
  Boolean                                  $show_diff = true,
  Optional[Variant[Boolean, Enum['mask']]] $enable    = undef,
  Optional[Boolean]                        $active    = undef,
  Optional[String]                         $restart   = undef,
  Optional[Boolean]                        $hasrestart = undef,
  Optional[Boolean]                        $hasstatus = undef,
  Boolean                                  $selinux_ignore_defaults = false,
  Hash[String[1], Any]                     $service_parameters = {},
  Boolean                                  $daemon_reload = true
) {
  include systemd

  assert_type(Systemd::Unit, $name)

  if $hasrestart =~ NotUndef {
    deprecation("systemd::unit_file - ${title}", 'hasrestart is deprecated and will be removed in Version 4 of the module')
  }

  if $hasstatus =~ NotUndef {
    deprecation("systemd::unit_file - ${title}", 'hasstatus is deprecated and will be removed in Version 4 of the module')
  }

  if $enable == 'mask' {
    $_target = '/dev/null'
  } else {
    $_target = $target
  }

  if $_target {
    $_ensure = 'link'
  } else {
    $_ensure = $ensure ? {
      'present' => 'file',
      default   => $ensure,
    }
  }

  file { "${path}/${name}":
    ensure                  => $_ensure,
    content                 => $content,
    source                  => $source,
    target                  => $_target,
    owner                   => $owner,
    group                   => $group,
    mode                    => $mode,
    show_diff               => $show_diff,
    selinux_ignore_defaults => $selinux_ignore_defaults,
  }

  if $daemon_reload {
    ensure_resource('systemd::daemon_reload', $name)

    File["${path}/${name}"] ~> Systemd::Daemon_reload[$name]
  }

  if $enable != undef or $active != undef {
    service { $name:
      ensure     => $active,
      enable     => $enable,
      restart    => $restart,
      provider   => 'systemd',
      hasrestart => $hasrestart,
      hasstatus  => $hasstatus,
      *          => $service_parameters,
    }

    if $ensure == 'absent' {
      if $enable or $active {
        fail("Can't ensure the unit file is absent and activate/enable the service at the same time")
      }
      Service[$name] -> File["${path}/${name}"]
    } else {
      File["${path}/${name}"] ~> Service[$name]

      if $daemon_reload {
        Systemd::Daemon_reload[$name] ~> Service[$name]
      }
    }
  }
}
