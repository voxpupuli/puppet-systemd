# frozen_string_literal: true

# Fact: udev
#
# Purpose:
#   Provide access to udev db data.
#
# Resolution:
#   Check if the kernel is linux and that the udevadm command is present.
#
# Caveats:
#
Facter.add(:udev) do
  confine(kernel: 'Linux')
  confine(:udevadm) { |x| x.key?('path') }

  def parse_dev(str)
    d = {}

    str.split(%r{\n}).each do |l|
      (type, data) = l.split(': ', 2)
      # See the source for a list of letter codes:
      # https://github.com/systemd/systemd/blob/a7b2aa658f35f4b9e91915eaa72afa648d0f9119/src/udev/udevadm-info.c#L182
      case type
      when 'N'
        d[:name] = data
      when 'P'
        d[:path] = data
      when 'S'
        d.key?(:symlink) ? d[:symlink].push(data) : d[:symlink] = [data]
      when 'E'
        (key, value) = data.split('=', 2)
        d.key?(:property) ? d[:property][key] = value : d[:property] = { key => value }
      when 'L'
        d[:priority] = data.to_i
      else
        # the source defines several other letter codes -- they do not seem to
        # be used on EL7/8
        raise "Unknown record: #{l}"
      end
    end

    d[:property]['DEVLINKS'] = d[:property]['DEVLINKS'].split if d.dig(:property, 'DEVLINKS')

    d
  end

  setcode do
    info = Facter::Core::Execution.exec("#{Facter.value(:udevadm)['path']} info -e")
    dev = info.split(%r{^\n}).map! do |d|
      parse_dev(d)
    end

    # The udev db contains information on [many] devices which do not have a
    # /dev/<file>. which are filtered out as they do not have a convenient
    # "name" by which to index them.
    {
      name: dev.each_with_object({}) { |i, x| x[i[:name]] = i if i.key?(:name) },
      path: dev.each_with_object({}) { |i, x| x[i[:path]] = i if i.key?(:path) },
    }
  end
end
