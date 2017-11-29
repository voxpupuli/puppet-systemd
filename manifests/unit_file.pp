# Creates a systemd unit file
#
# @api public
#
# @see systemd.unit(5)
#
# @attr name [Pattern['^.+\.(service|socket|device|mount|automount|swap|target|path|timer|slice|scope)$']]
#   The target unit file to create
#
#   * Must not contain ``/``
#
# @attr path
#   The main systemd configuration path
#
# @attr content
#   The full content of the unit file
#
#   * Mutually exclusive with ``$source``
#
# @attr source
#   The ``File`` resource compatible ``source``
#
#   * Mutually exclusive with ``$content``
#
# @attr target
#   If set, will force the file to be a symlink to the given target
#
#   * Mutually exclusive with both ``$source`` and ``$content``
#
# @attr manage_service
#    If set, will manage the service defined by the unit file
#
# @attr ensure_service
#    If set, will ensure the state of the resultant service, will
#    have no effect unless manage_service is true
#
# @attr enable_service
#    If set, will enable the service at OS startup, will
#    have no effect unless manage_service is true. 
#
define systemd::unit_file(
  Enum['present', 'absent', 'file'] $ensure         = 'present',
  Stdlib::Absolutepath              $path           = '/etc/systemd/system',
  Optional[String]                  $content        = undef,
  Optional[String]                  $source         = undef,
  Optional[Stdlib::Absolutepath]    $target         = undef,
  Boolean                           $manage_service = false,
  Enum['stopped','running']         $ensure_service = 'running',
  Boolean                           $enable_service  = true,
) {
  include ::systemd

  assert_type(Systemd::Unit, $name)

  if $target {
    $_ensure = 'link'
  } else {
    $_ensure = $ensure ? {
      'present' => 'file',
      default   => $ensure,
    }
  }

  file { "${path}/${name}":
    ensure  => $_ensure,
    content => $content,
    source  => $source,
    target  => $target,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Class['systemd::systemctl::daemon_reload'],
  }

  if $manage_service {
    service { $name:
      ensure => $ensure_service,
      enable => $enable_service,
    }
  }
}
