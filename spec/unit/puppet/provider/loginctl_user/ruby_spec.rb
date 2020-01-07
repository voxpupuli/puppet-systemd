require 'spec_helper'
require 'puppet'

provider_class = Puppet::Type.type(:loginctl_user).provider(:ruby)
describe provider_class do
  let(:common_params) do
    {
      title: 'foo',
      linger: 'enabled',
    }
  end

  context 'when listing instances' do
    it 'finds all entries' do
      expect(provider_class).to receive(:loginctl)
        .with('list-users', '--no-legend')
        .and_return("0 root\n42 foo\n314 bar\n")
      expect(provider_class).to receive(:loginctl)
        .with('show-user', '-p', 'Name', '-p', 'Linger', 'root', 'foo', 'bar')
        .and_return("Name=root\nLinger=no\n\nName=foo\nLinger=yes\n\nName=bar\nLinger=no\n")
      inst = provider_class.instances.map do |p|
      end

      expect(inst.size).to eq(3)
    end
  end

  it 'enables linger' do
    resource = Puppet::Type.type(:loginctl_user).new(common_params)
    expect(provider_class).to receive(:loginctl).with('enable-linger', 'foo')
    resource.provider.linger = :enabled
  end

  it 'disables linger' do
    resource = Puppet::Type.type(:loginctl_user).new(common_params)
    expect(provider_class).to receive(:loginctl).with('disable-linger', 'foo')
    resource.provider.linger = :disabled
  end
end
