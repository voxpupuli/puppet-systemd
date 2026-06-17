# @summary Purges previously managed `systemd::manage_unit` units
#
# Unit files inside `$paths` whose first line is the `# Deployed with puppet` header
# will be removed if they aren't currently being managed by puppet.
#
# @param daemon_reload
#   Whether to reload the systemd daemon after purging units
# @param paths
#   The path(s) to your systemd units.
# @param unit_types
#   The unit file types to purge. Defaults to every type that `systemd::manage_unit` can create.
#   Restrict this if you only want certain unit types purged.
class systemd::purge_units (
  Boolean                        $daemon_reload = true,
  Array[Stdlib::Absolutepath, 1] $paths         = ['/etc/systemd/system'],
  Array[Enum['automount', 'mount', 'path', 'service', 'slice', 'socket', 'swap', 'timer'], 1] $unit_types = [
    'automount',
    'mount',
    'path',
    'service',
    'slice',
    'socket',
    'swap',
    'timer',
  ],
) {
  systemd_purge_units { $paths:
    unit_types => $unit_types,
  }

  if $daemon_reload {
    systemd::daemon_reload { 'purge_units':
      subscribe => Systemd_purge_units[$paths],
    }
  }
}
