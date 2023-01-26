# @summary Install any systemd sub packages
# @api private
#
class systemd::install {
  if $systemd::manage_resolved and $systemd::resolved_package {
    package { $systemd::resolved_package:
      ensure => present,
    }
  }

  if $systemd::manage_timesyncd and $systemd::timesyncd_package {
    package { $systemd::timesyncd_package:
      ensure => present,
    }
  }
}
