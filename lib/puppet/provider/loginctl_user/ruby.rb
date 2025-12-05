# frozen_string_literal: true

# @summary custom provider to manage systemd user sessions/linger
# @see https://www.freedesktop.org/software/systemd/man/loginctl.html
# @see https://wiki.archlinux.org/title/Systemd/User
Puppet::Type.type(:loginctl_user).provide(:ruby) do
  desc 'custom provider to manage systemd user sessions/linger'

  commands loginctl: 'loginctl'

  def linger
    # loginctl is only successful if the user has an active session (so either logged in or lingering
    # so if loginctl fails, linger is definitly disabled, for users with an active session
    # (eg. logged in or running a timer or ...), the Linger property displays if lingering is activated.
    :enabled if loginctl('show-user', resource[:name], '--property=Linger', '--value').chomp == 'yes'
  rescue Puppet::ExecutionFailure
    :disabled
  end

  def linger=(value)
    case value
    when :enabled
      loginctl('enable-linger', resource[:name])
    when :disabled
      loginctl('disable-linger', resource[:name])
    end
  end
end
