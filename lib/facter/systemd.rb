# Fact: systemd
#
# Purpose: 
#   Determine whether SystemD is the init system on the node
#
# Resolution:
#   Check the name of the process 1 (ps -p 1)
#
# Caveats:
#

# Fact: systemd-version
#
# Purpose: 
#   Determine the version of systemd installed
#
# Resolution:
#  Check the output of systemctl --version
#
# Caveats:
#

Facter.add(:systemd) do
  confine :kernel => :linux
  setcode do
    Facter::Core::Execution.exec('ps -p 1 -o comm=') == 'systemd'
  end
end

Facter.add(:systemd_version) do
  confine :systemd => true
  setcode do
    Facter::Core::Execution.exec("systemctl --version | awk '/systemd/{ print $2 }'")
  end
end
