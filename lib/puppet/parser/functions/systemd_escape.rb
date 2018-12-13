require 'puppet/util/execution'

module Puppet::Parser::Functions
  newfunction(:systemd_escape, :type => :rvalue, :doc => <<-EOS
  Returns a file system path as escaped by systemd.
  https://www.freedesktop.org/software/systemd/man/systemd.unit.html#String%20Escaping%20for%20Inclusion%20in%20Unit%20Names
  EOS
  ) do |args|
    raise Puppet::ParseError, ("validate_cmd(): wrong number of arguments (#{args.length}; must be 1)") if args.length != 1
    path = args[0]
    cmd = "/bin/systemd-escape --path #{path}"
    escaped = Puppet::Util::Execution.execute(cmd)
    escaped.strip
  end
end