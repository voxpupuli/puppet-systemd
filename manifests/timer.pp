# @summary Create a timer and optionally a service unit to execute with the timer unit
#
# @api public
#
# @see https://www.freedesktop.org/software/systemd/man/systemd.timer.html systemd.timer(5)
#
# @param name [Pattern['^.+\.timer$]]
#   The target of the timer unit to create
#
# @param path
#   The main systemd configuration path
#
# @param timer_content
#   The full content of the timer unit file
#
#   * Mutually exclusive with ``$timer_source``
#
# @param timer_source
#   The ``File`` resource compatible ``source``
#
#   * Mutually exclusive with ``$timer_content``
#
# @param service_content
#   The full content of the service unit file
#
#   * Mutually exclusive with ``$service_source``
#
# @param service_source
#   The ``File`` resource compatible ``source``
#
#   * Mutually exclusive with ``$service_content``
#
# @param owner
#   The owner to set on the dropin file
#
# @param group
#   The group to set on the dropin file
#
# @param mode
#   The mode to set on the dropin file
#
# @param show_diff
#   Whether to show the diff when updating dropin file
#
# @param service_unit
#   If set then the service_unit will have this name.
#   If not set the service unit has the same name
#   as the timer unit with s/.timer/.service/
#
# @param active
#  If set to true or false the timer service will be maintained.
#  If true the timer service will be running and enabled, if false it will
#  explicitly stopped and disabled.
#
# @param enable
#   If set, will manage the state of the unit.
#
# @param ensure
#   Defines the desired state of the timer
#
# @param daemon_reload
#   Call `systemd::daemon_reload`
#
define systemd::timer (
  Enum['present', 'absent', 'file']        $ensure = 'present',
  Stdlib::Absolutepath                     $path = '/etc/systemd/system',
  Optional[String[1]]                      $timer_content = undef,
  Optional[String[1]]                      $timer_source = undef,
  Optional[String[1]]                      $service_content = undef,
  Optional[String[1]]                      $service_source  = undef,
  String[1]                                $owner = 'root',
  String[1]                                $group = 'root',
  Stdlib::Filemode                         $mode = '0444',
  Optional[Systemd::Unit]                  $service_unit = undef,
  Boolean                                  $show_diff = true,
  Optional[Variant[Boolean, Enum['mask']]] $enable = undef,
  Optional[Boolean]                        $active = undef,
  Boolean                                  $daemon_reload = true,
) {
  assert_type(Pattern['^.+\.timer$'],$name)

  if $service_content or $service_source {
    $_service_unit = pick($service_unit, "${basename($name,'.timer')}.service")

    systemd::unit_file { $_service_unit:
      ensure        => $ensure,
      content       => $service_content,
      source        => $service_source,
      path          => $path,
      owner         => $owner,
      group         => $group,
      mode          => $mode,
      show_diff     => $show_diff,
      before        => Systemd::Unit_file[$name],
      daemon_reload => $daemon_reload,
    }
  }

  systemd::unit_file { $name:
    ensure        => $ensure,
    content       => $timer_content,
    source        => $timer_source,
    path          => $path,
    owner         => $owner,
    group         => $group,
    mode          => $mode,
    show_diff     => $show_diff,
    enable        => $enable,
    active        => $active,
    daemon_reload => $daemon_reload,
  }
}
