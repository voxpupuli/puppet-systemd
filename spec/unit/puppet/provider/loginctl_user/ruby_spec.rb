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
    it 'should find all entries' do
      allow(provider_class).to receive(:loginctl).with('list-users', '--no-legend').and_return("0 root\n42 foo\n314 bar\n")
      allow(provider_class).to receive(:loginctl).with('show-user', '-p', 'Name', '-p', 'Linger', 'root', 'foo', 'bar').and_return("Name=root\nLinger=no\n\nName=foo\nLinger=yes\n\nName=bar\nLinger=no\n")
      inst = provider_class.instances.map do |p|
      end

      inst.size.is_expected.to eq(3)
    end
  end

  context 'when enabling linger' do
    it 'should enable linger' do
      resource = Puppet::Type::LoginctlUser.new(common_params)
    end
  end
end
