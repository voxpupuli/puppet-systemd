# frozen_string_literal: true

# https://puppet.com/docs/puppet/latest/fact_overview.html
Facter.add(:loginctl_linger_users) do
  confine kernel: 'Linux'

  setcode do
    users = []

    if Dir.exist?('/var/lib/systemd/linger')
      users = Dir.entries('/var/lib/systemd/linger')
      users.delete('.')
      users.delete('..')
    end

    users.append('root') unless users.include?('root') # root should always linger

    users
  end
end
