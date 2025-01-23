# @summary Generate unit file from template
#
# @api public
#
# @see systemd.unit(5)
#
# @example Generate a service
#   systemd::manage_unit { 'myrunner.service':
#     unit_entry    => {
#       'Description' => 'My great service',
#     },
#     service_entry => {
#       'Type'      => 'oneshot',
#       'ExecStart' => '/usr/bin/doit.sh',
#     },
#     install_entry => {
#       'WantedBy' => 'multi-user.target',
#     },
#   }
#
# @example Genenerate a path unit
#   systemd::manage_unit { 'passwd-mon.path':
#     ensure        => present,
#     unit_entry    => {
#       'Description' => 'Monitor the passwd file',
#     },
#     path_entry    => {
#       'PathModified' => '/etc/passwd',
#       'Unit'         => 'passwd-mon.service',
#     },
#     install_entry => {
#       'WantedBy' => 'multi-user.target',
#     },
#   }
#
# @example Generate a socket and service (xinetd style)
#  systemd::manage_unit {'arcd.socket':
#    ensure        => 'present',
#    unit_entry    => {
#      'Description' => 'arcd.service',
#    },
#    socket_entry  => {
#      'ListenStream' => 4241,
#      'Accept'       => true,
#      'BindIPv6Only' => 'both',
#    },
#    install_entry => {
#      'WantedBy' => 'sockets.target',
#    },
#  }
#
#  systemd::manage_unit{'arcd@.service':
#    ensure        => 'present',
#    enable        => true,
#    active        => true,
#    unit_entry    => {
#      'Description'   => 'arc sever for %i',
#    },
#    service_entry => {
#      'Type'          => 'simple',
#      'ExecStart'     => /usr/sbin/arcd /usr/libexec/arcd/arcd.pl,
#      'StandardInput' => 'socket',
#    },
#  }
#
# @example Mount a Filesystem and Use for a Service
#  systemd::manage_unit { 'var-lib-sss-db.mount':
#    ensure      => present,
#    unit_entry  => {
#      'Description' => 'Mount sss tmpfs db',
#    },
#    mount_entry => {
#      'What'    => 'tmpfs',
#      'Where'   => '/var/lib/sss/db',
#      'Type'    => 'tmpfs',
#      'Options' => 'size=300M,mode=0700,uid=sssd,gid=sssd,rootcontext=system_u:object_r:sssd_var_lib_t:s0',
#    },
#  }
#  systemd::manage_dropin { 'tmpfs-db.conf':
#    ensure     => present,
#    unit       => 'sssd.service',
#    unit_entry => {
#      'RequiresMountsFor' => '/var/lib/sss/db',
#    },
#  }
#
# @example Create and Mount a Swap File
#
#  systemd::manage_unit{'swapfile.swap':
#    ensure        => present,
#    enable        => true,
#    active        => true,
#    unit_entry    => {
#      'Description' => 'Mount /swapfile as a swap file',
#      'After'       => 'mkswap.service',
#      'Requires'    => 'mkswap.service',
#    },
#    swap_entry    => {
#      'What' => '/swapfile',
#    },
#    install_entry => {
#      'WantedBy' => 'multi-user.target',
#    },
#    require       => Systemd::Manage_unit['mkswap.service'],
#  }
#  systemd::manage_unit{'mkswap.service':
#    ensure        => present,
#    unit_entry    => {
#      'Description'         => 'Format a swapfile at /swapfile',
#      'ConditionPathExists' => '!/swapfile',
#    },
#    service_entry => {
#      'Type'      => 'oneshot',
#      'UMask'     => '0177',
#      'ExecStart' => [
#        '/usr/bin/dd if=/dev/zero of=/swapfile bs=1024 count=1000',
#        '/usr/sbin/mkswap /swapfile',
#      ],
#    },
#  }
#
# @example Remove a unit file
#  systemd::manage_unit { 'my.service':
#    ensure     => 'absent',
#  }
#
# @param name [Pattern['^[^/]+\.(service|socket|device|mount|automount|swap|target|path|timer|slice|scope)$']]
#   The target unit file to create
#
# @param ensure The state of the unit file to ensure
# @param path The main systemd configuration path
# @param owner The owner to set on the unit file
# @param group The group to set on the unit file
# @param mode The mode to set on the unit file
# @param show_diff Whether to show the diff when updating unit file
# @param enable If set, manage the unit enablement status
# @param active If set, will manage the state of the unit
# @param restart Specify a restart command manually. If left unspecified, a standard Puppet service restart happens
# @param selinux_ignore_defaults
#   maps to the same param on the file resource for the unit. false in the module because it's false in the file resource type
# @param service_parameters
#   hash that will be passed with the splat operator to the service resource
# @param daemon_reload
#   call `systemd::daemon-reload` to ensure that the modified unit file is loaded
# @param service_restart
#   restart (notify) the service when unit file changed
#
# @param unit_entry  key value pairs for [Unit] section of the unit file.
# @param slice_entry key value pairs for [Slice] section of the unit file
# @param service_entry key value pairs for [Service] section of the unit file.
# @param install_entry key value pairs for [Install] section of the unit file.
# @param timer_entry key value pairs for [Timer] section of the unit file
# @param path_entry key value pairs for [Path] section of the unit file.
# @param socket_entry kev value paors for [Socket] section of the unit file.
# @param mount_entry kev value pairs for [Mount] section of the unit file.
# @param swap_entry kev value pairs for [Swap] section of the unit file.
#
define systemd::manage_unit (
  Enum['present', 'absent']                $ensure                  = 'present',
  Stdlib::Absolutepath                     $path                    = '/etc/systemd/system',
  String                                   $owner                   = 'root',
  String                                   $group                   = 'root',
  Stdlib::Filemode                         $mode                    = '0444',
  Boolean                                  $show_diff               = true,
  Optional[Variant[Boolean, Enum['mask']]] $enable                  = undef,
  Optional[Boolean]                        $active                  = undef,
  Optional[String]                         $restart                 = undef,
  Boolean                                  $selinux_ignore_defaults = false,
  Hash[String[1], Any]                     $service_parameters      = {},
  Boolean                                  $daemon_reload           = true,
  Boolean                                  $service_restart         = true,
  Optional[Systemd::Unit::Install]         $install_entry           = undef,
  Optional[Systemd::Unit::Unit]            $unit_entry              = undef,
  Optional[Systemd::Unit::Slice]           $slice_entry             = undef,
  Optional[Systemd::Unit::Service]         $service_entry           = undef,
  Optional[Systemd::Unit::Timer]           $timer_entry             = undef,
  Optional[Systemd::Unit::Path]            $path_entry              = undef,
  Optional[Systemd::Unit::Socket]          $socket_entry            = undef,
  Optional[Systemd::Unit::Mount]           $mount_entry             = undef,
  Optional[Systemd::Unit::Swap]            $swap_entry              = undef,
) {
  assert_type(Systemd::Unit, $name)

  if $timer_entry and $name !~ Pattern['^[^/]+\.timer'] {
    fail("Systemd::Manage_unit[${name}]: timer_entry is only valid for timer units")
  }

  if $path_entry and $name !~ Pattern['^[^/]+\.path'] {
    fail("Systemd::Manage_unit[${name}]: path_entry is only valid for path units")
  }

  if $socket_entry and $name !~ Pattern['^[^/]+\.socket'] {
    fail("Systemd::Manage_unit[${name}]: socket_entry is only valid for socket units")
  }

  if $slice_entry and $name !~ Pattern['^[^/]+\.slice'] {
    fail("Systemd::Manage_unit[${name}]: slice_entry is only valid for slice units")
  }

  if $mount_entry and $name !~ Pattern['^[^/]+\.mount'] {
    fail("Systemd::Manage_unit[${name}]: mount_entry is only valid for mount units")
  }

  if $swap_entry and $name !~ Pattern['^[^/]+\.swap'] {
    fail("Systemd::Manage_unit[${name}]: swap_entry is only valid for swap units")
  }

  if $ensure != 'absent' and  $name =~ Pattern['^[^/]+\.service'] and !$service_entry {
    fail("Systemd::Manage_unit[${name}]: service_entry is required for service units")
  }

  systemd::unit_file { $name:
    ensure                  => $ensure,
    path                    => $path,
    owner                   => $owner,
    group                   => $group,
    mode                    => $mode,
    show_diff               => $show_diff,
    enable                  => $enable,
    active                  => $active,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    service_parameters      => $service_parameters,
    daemon_reload           => $daemon_reload,
    service_restart         => $service_restart,
    content                 => epp('systemd/unit_file.epp', {
        'unit_entry'    => $unit_entry,
        'slice_entry'   => $slice_entry,
        'service_entry' => $service_entry,
        'install_entry' => $install_entry,
        'timer_entry'   => $timer_entry,
        'path_entry'    => $path_entry,
        'socket_entry'  => $socket_entry,
        'mount_entry'   => $mount_entry,
        'swap_entry'    => $swap_entry,
    }),
  }
}
