# @summary Configures oneshot service and timer for trivial commands
#
# @api public
#
# @see https://www.freedesktop.org/software/systemd/man/systemd.timer.html systemd.timer(5)
#
# @param name [Pattern['^.+\.timer$]]
#   The target of the timer unit to create
#
# @param description Specity a timer description to add to service and timer unit files
#
# @param command Command line and options to run
#
# @param timings Specify timing parameters for timer unit as to when the timer should run
#
# @param ensure
#   Defines the desired state of the timer
#
# @param active
#  If set to true or false the timer service will be maintained.
#  If true the timer service will be running and enabled, if false it will
#  explicitly stopped and disabled.
#
# @param enable
#   If set, will manage the state of the unit.
#
# @param after List of systemd units the service will only run `After`
#
# @example Run a command on boot and once per hour thereafter
#   systemd::simpletimer { 'create-file.timer':
#     ensure              => present,
#     command             => '/usr/bin/touch /tmp/file',
#     timings             => {
#       'OnBootsec'       => 0,
#       'OnUnitActiveSec' => '1h',
#     }
#     enable              => true,
#     active              => true,
#
# @example Run a command weekly only after the network is up
#   systemd::simpletimer { 'create-file-weekly.timer':
#     ensure              => present,
#     command             => '/usr/bin/touch /tmp/weekly',
#     description         => 'Touch a file',
#     timings             => {
#       'OnCalendar' => 'weekly',
#     },
#     enable              => true,
#     active              => true,
#     after               => ['network-online.target'],
#   }
#
define systemd::simpletimer (
  String[1] $command,
  Hash[Enum['OnActiveSec', 'OnBootSec', 'OnStartupSec', 'OnUnitActiveSec', 'OnUnitInactiveSec', 'OnCalendar'],Variant[String[1],Integer],1] $timings,
  Optional[String[1]] $description                 = undef,
  Enum['present', 'absent'] $ensure                = 'present',
  Optional[Variant[Boolean, Enum['mask']]] $enable = undef,
  Optional[Boolean]                        $active = undef,
  Optional[Array[Systemd::Unit,1]]         $after  = undef,
) {
  assert_type(Pattern['^.+\.timer$'],$name)

  systemd::timer { $name:
    ensure          => $ensure,
    enable          => $enable,
    active          => $active,
    timer_content   => epp('systemd/simpletimer.timer.epp',   { 'description' => $description, 'timings' => $timings }),
    service_content => epp('systemd/simpletimer.service.epp', { 'description' => $description, 'command' => $command, 'after' => $after }),
  }
}
