# @summary Install any systemd sub packages
# @api private
#
class systemd::install {
  if $systemd::manage_networkd and $systemd::networkd_package {
    package { $systemd::networkd_package:
      ensure => present,
    }
  }

  if $systemd::manage_oomd and $systemd::oomd_package {
    package { $systemd::oomd_package:
      ensure => present,
    }
  }

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

  if $systemd::manage_nspawn and $systemd::nspawn_package {
    package { $systemd::nspawn_package:
      ensure => present,
    }
  }
}
