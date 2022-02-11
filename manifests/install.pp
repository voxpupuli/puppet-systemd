# @summary Install any systemd sub packages
# @api private
#
class systemd::install {
  if $systemd::manage_resolved and $systemd::resolved_package {
    package { $systemd::resolved_package:
      ensure => present,
    }
  }
}
