# @summary Construct command array for running `systemctl --user` for particular arguments
# @param user User instance of `systemd --user` to connect to.
# @param arguments Arguments to run after `systemctl --user`
#
# @return Array Array of command and arguments
# @example Start a user service with an exec
#   exec { 'start_service':
#    command => systemd::systemctl_user('santa', 'start myservice.service'),
#   }
function systemd::systemctl_user(String[1] $user, Array[String[1],1] $arguments) >> Array {
  # Why is runuser being used here for older systemds?
  # More obvious command arrays to return would be:
  # * ['run0','--user',$user,'systemctl','--user'] + $arguments
  # * ['systemctl', '--user', '--machine', "${user}@.host"] + $arguments
  # * ['systemd-run','--wait','--pipe', 'systemctl', '--user', '--machine', "${user}@.host"] + $arguments
  # However none of these work when puppet is run as a background service. They only work with
  # puppet apply in the foreground. Reason is unclear, possibly polkit blocking access
  # https://github.com/voxpupuli/puppet-systemd/issues/459

  $_cmd_array  = Integer($facts['systemd_version']) < 256 ? {
    true    => [
      'runuser', '-u', $user, '--' ,'/usr/bin/bash', '-c',
      "env XDG_RUNTIME_DIR=/run/user/\$(id -u) /usr/bin/systemctl --user ${arguments.join(' ')}",
    ],
    default => ['run0','--user',$user,'/usr/bin/systemctl','--user'] + $arguments,
  }

  return $_cmd_array
}
