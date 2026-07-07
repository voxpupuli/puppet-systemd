# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'fileutils'

systemd_purge_units = Puppet::Type.type(:systemd_purge_units)

describe systemd_purge_units do
  let(:dir) { Dir.mktmpdir('systemd_purge_units') }

  after do
    FileUtils.remove_entry(dir)
  end

  # Write a file in the purge directory, optionally with the puppet header as its first line.
  def write_unit(dir, name, header: true, body: "[Unit]\nDescription=test\n")
    content = +''
    content << "# Deployed with puppet\n" if header
    content << body
    path = File.join(dir, name)
    File.write(path, content)
    path
  end

  # Build a catalog containing the purge resource plus any pre-existing (managed) File resources.
  def generate_for(resource, managed_paths: [])
    catalog = Puppet::Resource::Catalog.new
    catalog.add_resource(resource)
    managed_paths.each do |path|
      catalog.add_resource(Puppet::Type.type(:file).new(path: path, ensure: :present))
    end
    resource.generate || []
  end

  # The paths the resource would purge, as plain strings.
  def purged_paths(resource, **kwargs)
    generate_for(resource, **kwargs).map { |file| file[:path] }
  end

  describe 'parameter validation' do
    it 'requires path to be absolute' do
      expect { described_class.new(path: 'relative/path') }.to raise_error(Puppet::Error, %r{path must be fully qualified})
    end

    it 'accepts an absolute path' do
      expect { described_class.new(path: '/etc/systemd/system') }.not_to raise_error
    end

    it 'defaults unit_types to all eight manage_unit types' do
      resource = described_class.new(path: '/etc/systemd/system')
      expect(resource[:unit_types]).to contain_exactly('automount', 'mount', 'path', 'service', 'slice', 'socket', 'swap', 'timer')
    end

    it 'accepts a restricted list of unit_types' do
      resource = described_class.new(path: '/etc/systemd/system', unit_types: ['service'])
      expect(resource[:unit_types]).to eq(['service'])
    end

    it 'rejects an unknown unit type' do
      expect { described_class.new(path: '/etc/systemd/system', unit_types: ['bogus']) }.to raise_error(Puppet::Error, %r{unit_types must be one of})
    end
  end

  describe '#generate' do
    it 'purges unmanaged unit files carrying the puppet header' do
      write_unit(dir, 'orphan.service')
      write_unit(dir, 'orphan.timer')

      resource = described_class.new(path: dir)
      expect(purged_paths(resource)).to contain_exactly(
        File.join(dir, 'orphan.service'),
        File.join(dir, 'orphan.timer'),
      )
    end

    it 'purges every unit type manage_unit can create by default' do
      %w[automount mount path service slice socket swap timer].each do |type|
        write_unit(dir, "orphan.#{type}")
      end

      resource = described_class.new(path: dir)
      expect(purged_paths(resource).length).to eq(8)
    end

    it 'generates File resources with ensure => absent' do
      write_unit(dir, 'orphan.service')

      resource = described_class.new(path: dir)
      generated = generate_for(resource)
      expect(generated).to all(be_a(Puppet::Type.type(:file)))
      expect(generated.map { |f| f[:ensure] }).to all(eq(:absent))
    end

    it 'does not purge files that are managed in the catalog' do
      managed = write_unit(dir, 'managed.service')
      write_unit(dir, 'orphan.service')

      resource = described_class.new(path: dir)
      expect(purged_paths(resource, managed_paths: [managed])).to contain_exactly(File.join(dir, 'orphan.service'))
    end

    it 'normalizes paths so a trailing slash does not orphan a managed file' do
      managed = write_unit(dir, 'managed.service')

      # Resource path has a trailing slash; catalog path does not.
      resource = described_class.new(path: "#{dir}/")
      expect(purged_paths(resource, managed_paths: [managed])).to be_empty
    end

    it 'ignores files without the puppet header' do
      write_unit(dir, 'foreign.service', header: false)

      resource = described_class.new(path: dir)
      expect(purged_paths(resource)).to be_empty
    end

    it 'only treats the header as valid when it is the first line' do
      write_unit(dir, 'late_header.service', header: false, body: "[Unit]\n# Deployed with puppet\n")

      resource = described_class.new(path: dir)
      expect(purged_paths(resource)).to be_empty
    end

    it 'ignores files whose extension is not a unit type' do
      write_unit(dir, 'notes.txt')

      resource = described_class.new(path: dir)
      expect(purged_paths(resource)).to be_empty
    end

    it 'restricts purging to the configured unit_types' do
      write_unit(dir, 'orphan.service')
      write_unit(dir, 'orphan.timer')

      resource = described_class.new(path: dir, unit_types: ['timer'])
      expect(purged_paths(resource)).to contain_exactly(File.join(dir, 'orphan.timer'))
    end

    it 'does not descend into or purge directories named like units' do
      FileUtils.mkdir(File.join(dir, 'multi-user.target.wants'))
      Dir.mkdir(File.join(dir, 'subdir.service'))

      resource = described_class.new(path: dir)
      expect(purged_paths(resource)).to be_empty
    end

    it 'does not follow or purge symlinks' do
      target = write_unit(dir, 'orphan.service')
      File.symlink(target, File.join(dir, 'link.service'))

      resource = described_class.new(path: dir)
      # The real file is purged, the symlink is left alone.
      expect(purged_paths(resource)).to contain_exactly(target)
    end

    it 'warns and purges nothing when the path does not exist' do
      missing = File.join(dir, 'does-not-exist')
      resource = described_class.new(path: missing)

      expect(resource).to receive(:warning).with(%r{does not exist or is not a directory})
      expect(purged_paths(resource)).to be_empty
    end
  end

  describe '#purged?' do
    it 'is true after generate finds units to purge' do
      write_unit(dir, 'orphan.service')
      resource = described_class.new(path: dir)
      generate_for(resource)
      expect(resource.purged?).to be(true)
    end

    it 'is false when generate finds nothing to purge' do
      resource = described_class.new(path: dir)
      generate_for(resource)
      expect(resource.purged?).to be(false)
    end
  end
end
