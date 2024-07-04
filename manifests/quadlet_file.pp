# @summary Creates a systemd Podman Quadlet file
# Quadlet will generate a unit file, and this service can be managed by puppet.
# @api public
#
# @see podman.systemd.unit(5)
#
# @param name
#   The name of the quadlet file
#
# @param ensure
#   The state of the quadlet file to ensure
#
# @param content
#   The full content of the quadlet file
#
# @param path
#   The path where the quadlet file will be created
#   For systemd in user mode use any of
#   - ~/.config/containers/systemd
#   - /etc/containers/systemd/users/$(UID)
#
#   For global systemd use any of:
#   - /etc/containers/systemd
#   - /usr/share/containers/systemd
#
# @param source
#   The ``File`` resource compatible ``source``
#
#   * Mutually exclusive with ``$content``
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
# @param enable
#   If set, will manage the unit enablement status.
#
# @param active
#   If set, will manage the state of the unit.
#
# @param restart
#   Specify a restart command manually. If left unspecified, a standard Puppet service restart happens.
#
# @param service_parameters
#   hash that will be passed with the splat operator to the service resource
#
# @param daemon_reload
#   call `systemd::daemon-reload` to ensure that the modified unit file is loaded
#
# @param service_restart
#   restart (notify) the service when unit file changed
define systemd::quadlet_file (
  Enum['present', 'absent']                $ensure    = 'present',
  Stdlib::Absolutepath                     $path      = '/etc/containers/systemd',
  Optional[Variant[String, Sensitive[String], Deferred]] $content = undef,
  Optional[String]                         $source    = undef,
  String[1]                                $owner     = 'root',
  String[1]                                $group     = 'root',
  String[1]                                $mode      = '0444',
  Optional[Boolean]                        $enable    = undef,
  Optional[Boolean]                        $active    = undef,
  Optional[String]                         $restart   = undef,
  Hash[String[1], Any]                     $service_parameters = {},
  Boolean                                  $daemon_reload = true,
  Boolean                                  $service_restart = true,
) {
  include systemd
  assert_type(Systemd::Quadlet, $name)
  $service_name=regsubst($name, '^(.*)\\..*', '\\1.service')

  file { "${path}/${name}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
  }

  if $daemon_reload {
    ensure_resource('systemd::daemon_reload', $name)

    File["${path}/${name}"] ~> Systemd::Daemon_reload[$name]
  }

  if $enable != undef or $active != undef {
    service { $service_name:
      ensure   => $active,
      enable   => $enable,
      restart  => $restart,
      provider => 'systemd',
      *        => $service_parameters,
    }

    if $ensure == 'absent' {
      if $enable or $active {
        fail("Can't ensure the unit file is absent and activate/enable the service at the same time")
      }
      Service[$service_name] -> File["${path}/${name}"]
    } elsif $service_restart {
      File["${path}/${name}"] ~> Service[$service_name]

      if $daemon_reload {
        Systemd::Daemon_reload[$name] ~> Service[$service_name]
      }
    }
  }
}
