# @summary Possible keys for the [Service] section of a unit file
# @see https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @see https://www.freedesktop.org/software/systemd/man/systemd.exec.html
#
type Systemd::Unit::Service = Struct[
  {
    Optional['Type']                      => Enum['simple', 'exec', 'forking', 'oneshot', 'dbus', 'notify', 'idle'],
    Optional['ExitType']                  => Enum['main', 'cgroup'],
    Optional['RemainAfterExit']           => Boolean,
    Optional['GuessMainPID']              => Boolean,
    Optional['PIDFile']                   => Stdlib::Unixpath,
    Optional['BusName']                   => String[1],
    Optional['ExecStart']                 => Variant[Systemd::Unit::Service::Exec,Array[Systemd::Unit::Service::Exec,1]],
    Optional['ExecStartPre']              => Variant[Systemd::Unit::Service::Exec,Array[Systemd::Unit::Service::Exec,1]],
    Optional['ExecStartPost']             => Variant[Systemd::Unit::Service::Exec,Array[Systemd::Unit::Service::Exec,1]],
    Optional['ExecCondition']             => Variant[Systemd::Unit::Service::Exec,Array[Systemd::Unit::Service::Exec,1]],
    Optional['ExecReload']                => Variant[Systemd::Unit::Service::Exec,Array[Systemd::Unit::Service::Exec,1]],
    Optional['ExecStop']                  => Variant[Systemd::Unit::Service::Exec,Array[Systemd::Unit::Service::Exec,1]],
    Optional['ExecStopPost']              => Variant[Systemd::Unit::Service::Exec,Array[Systemd::Unit::Service::Exec,1]],
    Optional['RestartSec']                => String,
    Optional['TimeoutStartSec']           => String,
    Optional['TimeoutStopSec']            => String,
    Optional['TimeoutAbortSec']           => String,
    Optional['TimeoutAbortSec']           => String,
    Optional['TimeoutSec']                => String,
    Optional['TimeoutStartFailureMode']   => Enum['terminate', 'abort', 'kill'],
    Optional['TimeoutStopFailureMode']    => Enum['terminate', 'abort', 'kill'],
    Optional['RuntimeMaxSec']             => String,
    Optional['RuntimeRandomizedExtraSec'] => String,
    Optional['WatchdogSec']               => String,
    Optional['Restart']                   => Enum['no', 'on-success', 'on-failure', 'on-abnormal', 'on-watchdog', 'on-abort', 'always'],
    Optional['SuccessExitStatus']         => String,
    Optional['RestartPreventExitStatus']  => String,
    Optional['RestartForceExitStatus']    => String,
    Optional['RootDirectoryStartOnly']    => Boolean,
    Optional['NonBlocking']               => Boolean,
    Optional['NotifyAccess']              => Enum['none', 'default', 'main', 'exec',  'all'],
    Optional['OOMPolicy']                 => Enum['continue', 'stop','kill'],
    Optional['OOMScoreAdjust']            => Integer[-1000,1000],
    Optional['Environment']               => String,
    Optional['EnvironmentFile']           => Variant[Stdlib::Unixpath,Pattern[/-\/.*/]],
  }
]
