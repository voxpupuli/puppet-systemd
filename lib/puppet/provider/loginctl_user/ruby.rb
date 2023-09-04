# frozen_string_literal: true

# @summary custom provider to manage systemd user sessions/linger
# @see https://www.freedesktop.org/software/systemd/man/loginctl.html
# @see https://wiki.archlinux.org/title/Systemd/User
Puppet::Type.type(:loginctl_user).provide(:ruby) do
  desc 'custom provider to manage systemd user sessions/linger'
  commands loginctl: 'loginctl'

  def self.instances
    users = loginctl('list-users', '--no-legend').split("\n").map { |l| l.split[1] }
    loginctl('show-user', '-p', 'Name', '-p', 'Linger', *users).split("\n\n").map do |u|
      user = u.split("\n").to_h { |f| f.split('=') }
      linger = if user['Linger'] == 'yes'
                 'enabled'
               else
                 'disabled'
               end
      new(name: user['Name'],
          linger: linger)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      resources[prov.name].provider = prov if resources[prov.name]
    end
  end

  mk_resource_methods

  def linger=(value)
    case value
    when :enabled
      loginctl('enable-linger', resource[:name])
    when :disabled
      loginctl('disable-linger', resource[:name])
    end
  end
end
