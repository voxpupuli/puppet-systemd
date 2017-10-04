# **NOTE: THIS IS A [PRIVATE](https://github.com/puppetlabs/puppetlabs-stdlib#assert_private) CLASS**
#
# This class provides an abstract way to trigger systemd-timesyncd
#
# @param ensure
#   The state that the ``networkd`` service should be in
#
# @param $ntp_server
#   comma separated list of ntp servers, will be combined with interface specific
#   addresses from systemd-networkd. requires puppetlabs-inifile
#
# @param fallback_ntp_server
#   A space-separated list of NTP server host names or IP addresses to be used
#   as the fallback NTP servers. Any per-interface NTP servers obtained from
#   systemd-networkd take precedence over this setting. requires puppetlabs-inifile
class systemd::timesyncd (
  Enum['stopped','running'] $ensure     = $systemd::timesyncd_ensure,
  Optional[String] $ntp_server          = $systemd::ntp_server,
  Optional[String] $fallback_ntp_server = $systemd::fallback_ntp_server,
){

  assert_private()

  $_enable_timesyncd = $ensure ? {
    'stopped' => false,
    'running' => true,
    default   => $ensure,
  }

  service{ 'systemd-timesyncd':
    ensure => $ensure,
    enable => $_enable_timesyncd,
  }

  if $ntp_server {
    ini_setting{'ntp_server':
      ensure  => 'present',
      value   => $ntp_server,
      setting => 'NTP',
      section => 'Time',
      path    => '/etc/systemd/timesyncd.conf',
      notify  => Service['systemd-timesyncd'],
    }
  }

  if $fallback_ntp_server {
    ini_setting{'fallback_ntp_server':
      ensure  => 'present',
      value   => $fallback_ntp_server,
      setting => 'FallbackNTP',
      section => 'Time',
      path    => '/etc/systemd/timesyncd.conf',
      notify  => Service['systemd-timesyncd'],
    }
  }
}
