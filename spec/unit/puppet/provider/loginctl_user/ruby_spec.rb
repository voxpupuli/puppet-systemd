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

  context 'when enabling linger' do
    it 'should enable linger' do
      resource = Puppet::Type::LoginctlUser.new(common_params)
    end
  end
end
