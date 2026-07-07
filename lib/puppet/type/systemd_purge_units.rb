# frozen_string_literal: true

require 'pathname'

Puppet::Type.newtype(:systemd_purge_units) do
  attr_reader :purged_units

  # The unit file types that `systemd::manage_unit` is able to create. Every unit
  # file it writes starts with the `# Deployed with puppet` header, so any of
  # these extensions are safe to purge.
  valid_unit_types = %w[
    automount
    mount
    path
    service
    slice
    socket
    swap
    timer
  ].freeze

  @doc = <<-EOT
  This is a metatype to purge unmanaged systemd units that were previously created with the `systemd::manage_unit` defined type.

  Set the name of the resource to your systemd unit file path. (eg. `/etc/systemd/system`).
  Any unmanaged unit files in that directory whose first line is `# Deployed with puppet` will be removed.
  By default all unit types that `systemd::manage_unit` can create are considered, but this can be narrowed with the `unit_types` parameter.
  EOT

  # Similar to crayfishx/purge, this ensurable block is here to make sure _this_ resource
  # enters a changed state when there are any generated resources that have been purged.
  ensurable do
    defaultto(:purged)
    newvalue(:purgable)
    newvalue(:purged) do
      true
    end

    def retrieve
      if @resource.purged?
        :purgable
      else
        :purged
      end
    end
  end

  newparam(:path, namevar: true) do
    desc 'The fully qualified directory to purge unit files from.'

    validate do |value|
      raise ArgumentError, 'path must be fully qualified.' unless Puppet::Util.absolute_path?(value, :posix)
    end
  end

  newparam(:unit_types) do
    desc <<-EOT
      The unit file types to purge. Defaults to every type that `systemd::manage_unit` can create.
      Give an array to restrict purging to specific types, eg. `['service', 'timer']`.
    EOT

    defaultto(valid_unit_types)

    munge { |value| Array(value) }

    validate do |value|
      Array(value).each do |type|
        raise ArgumentError, "unit_types must be one of #{valid_unit_types.join(', ')}; got '#{type}'" unless valid_unit_types.include?(type)
      end
    end
  end

  def generate
    @purged_units = []

    unless File.directory?(self[:path])
      warning("#{self[:path]} does not exist or is not a directory; nothing to purge")
      return @purged_units
    end

    dir = normalize_path(self[:path])
    extensions = Array(self[:unit_types]).map { |type| ".#{type}" }

    Dir.foreach(dir) do |entry|
      file_path = normalize_path(File.join(dir, entry))

      # Skip symlinks (eg. systemd enablement links) so we never follow or remove them.
      next if File.symlink?(file_path)
      next unless File.file?(file_path)
      next unless extensions.include?(File.extname(entry))
      next unless contains_puppet_header?(file_path)
      next if in_catalog?(file_path)

      debug "systemd unit #{entry} was not in catalog and will be purged from #{dir}"

      file_opts = {
        ensure: :absent,
        path: file_path,
      }

      # Copy Systemd_purge_units resource metaparameters into generated File resources.
      # :alias is excluded because copying it onto more than one File would raise a
      # duplicate alias error.
      Puppet::Type.metaparams.each do |metaparam|
        next if metaparam == :alias

        file_opts[metaparam] = self[metaparam] unless self[metaparam].nil?
      end

      @purged_units << Puppet::Type.type(:file).new(file_opts)
    end

    @purged_units
  end

  # Returns true if the first line of the file is the puppet header. Only the
  # first line is read so this stays cheap on large unit files.
  def contains_puppet_header?(file)
    first_line = File.open(file, &:gets)
    !first_line.nil? && first_line.start_with?('# Deployed with puppet')
  end

  def in_catalog?(file)
    managed_files.include?(file)
  end

  # Returns array of (normalized) file paths of all File resources in the catalog
  def managed_files
    @managed_files ||= catalog.resources.filter_map do |resource|
      next unless resource.is_a?(Puppet::Type.type(:file))

      normalize_path(resource[:path])
    end
  end

  # Lexically normalize a path (collapse `//`, strip trailing slashes, resolve `.`/`..`)
  # so comparisons against catalog paths are robust to formatting differences.
  def normalize_path(path)
    Pathname.new(path).cleanpath.to_s
  end

  def purged?
    Array(@purged_units).any?
  end
end
