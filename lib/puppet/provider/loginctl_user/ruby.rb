Puppet::Type.type(:loginctl_user).provide(:ruby) do
  commands loginctl: 'loginctl'

  def self.instances
    users = loginctl('list-users', '--no-legend').split("\n").map { |l| l.split[1] }
    loginctl('show-user', '-p', 'Name', '-p', 'Linger', *users).split("\n\n").map do |u|
      user = u.split("\n").map { |f| f.split('=') }.to_h
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
      if resources[prov.name]
        resources[prov.name].provider = prov
      end
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
