Puppet::Type.type(:loginctl_user).provide(:ruby) do
  commands :loginctl => 'loginctl'

  def self.instances
    users = loginctl('list-users', '--no-legend').split("\n").map { |l| l.split[1] }
    loginctl('show-user', '-p', 'Name', '-p', 'Linger', *users).split("\n\n").map do |u|
      user = u.split("\n").map { |f| f.split("=") }.to_h
      if user['Linger'] == 'yes'
        linger = 'enabled'
      else
        linger = 'disabled'
      end
      new({
        :name   => user['Name'],
        :linger => linger,
      })
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  mk_resource_methods
end
