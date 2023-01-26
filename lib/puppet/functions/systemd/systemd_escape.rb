# frozen_string_literal: true

# @summary Escape strings by call the `systemd-escape` command in the background.
Puppet::Functions.create_function(:'systemd::systemd_escape') do
  # @param input Input string
  # @param path Use path (-p) ornon-path  style escaping.
  dispatch :escape do
    param 'String', :input
    optional_param 'Optional[Boolean]', :path
    return_type 'String'
  end

  def escape(input, path = false)
    args = []

    args.push('--path') if path

    args.push(input)
    exec_systemd(args)
  end

  def exec_systemd(*args)
    exec_args = { failonfail: true, combine: false }
    escaped = Puppet::Util::Execution.execute(['systemd-escape', args], **exec_args)
    escaped.strip
  end
end
