# Fact: initsystem
#
# Purpose:
#   Determine the init system in use on the node
#
# Resolution:
#   Check the output of `/proc/1/exe --version` for identifying substrings:
#   * runit will include "runit" substring.
#   * systemd will include "systemd" substring.
#   * upstart will include "upstart" substring.
#   * sysvinit will include "invalid option" substring.
#   * If none of the above are present, sets :initsystem => :unknown
#
# Caveats:
#

# Fact: systemd
#
# Purpose:
#   Determine whether systemd is the init system on the node
#
# Resolution:
#   Returns true if :initsystem => :systemd
#   Returns false otherwise
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

Facter.add(:initsystem) do
  confine :kernel => :linux
  setcode do
    output = Facter::Util::Resolution.exec('/proc/1/exe --version')
    if output.include?('invalid option')
      'sysvinit'
    elsif output.include?('runit')
      'runit'
    elsif output.include?('systemd')
      'systemd'
    elsif output.include?('upstart')
      'upstart'
    else
      'unknown'
    end
  end
end

Facter.add(:systemd) do
  confine :kernel => :linux
  setcode do
    Facter.value(:initsystem) == :systemd
  end
end

Facter.add(:systemd_version) do
  confine :systemd => true
  setcode do
    Facter::Util::Resolution.exec("systemctl --version | awk '/systemd/{ print $2 }'")
  end
end
