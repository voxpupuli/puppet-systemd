# @api private
#
# This class provides a solution to manage system and/or user service manager settings
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd-system.conf.html
#
# @param manage_accounting
#   When enabled, the different accounting options (network traffic, IO,
#   CPU util...) are enabled for units.
#
# @param accounting_settings
#   Hash of the different accounting options. This highly depends on the used
#   systemd version. The module provides sane defaults per operating system
#   using Hiera.
#
# @param manage_system_conf
#   Should system service manager configurations be managed
#
# @param system_settings
#   Config Hash that is used to configure settings in system.conf
#   NOTE: It's currently impossible to have multiple entries of the same key in
#   the settings.
#
# @param manage_user_conf
#   Should user service manager configurations be managed
#
# @param user_settings
#   Config Hash that is used to configure settings in user.conf
#   NOTE: It's currently impossible to have multiple entries of the same key in
#   the settings.
#
class systemd::service_manager (
  Boolean $manage_accounting = $systemd::manage_accounting,
  Boolean $manage_system_conf = $systemd::manage_system_conf,
  Boolean $manage_user_conf = $systemd::manage_user_conf,
  Systemd::ServiceManagerSettings $accounting_settings = $systemd::accounting,
  Systemd::ServiceManagerSettings $system_settings = $systemd::system_settings,
  Systemd::ServiceManagerSettings $user_settings = $systemd::user_settings,
) {
  assert_private()

  $real_system_settings = case [$manage_accounting, $manage_system_conf] {
    [true, false]: { $accounting_settings }
    [false, true]: { $system_settings }
    [true, true]:  { $system_settings + $accounting_settings } # Accounting settings have preference
    default: { ({}) } # Empty Hash otherwise
  }

  $real_system_settings.each |$option, $value| {
    $vh = $value ? {
      Systemd::SettingEnsure => $value,
      default => { value => $value },
    }

    ini_setting { "system/${option}":
      ensure  => $vh.get('ensure', 'present'),
      path    => '/etc/systemd/system.conf',
      section => 'Manager',
      setting => $option,
      value   => $vh['value'],
    }
  }

  if $manage_user_conf {
    $user_settings.each |$option, $value| {
      $vh = $value ? {
        Systemd::SettingEnsure => $value,
        default => { value => $value },
      }

      ini_setting { "user/${option}":
        ensure  => $vh.get('ensure', 'present'),
        path    => '/etc/systemd/user.conf',
        section => 'Manager',
        setting => $option,
        value   => $vh['value'],
      }
    }
  }
}
