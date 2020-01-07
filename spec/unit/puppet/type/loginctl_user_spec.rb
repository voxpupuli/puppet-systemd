require 'spec_helper'

loginctl_user = Puppet::Type.type(:loginctl_user)

describe loginctl_user do
  let(:common_params) do
    {
      title: 'foo',
    }
  end

  it 'disables linger by default' do
    resource = Puppet::Type.type(:loginctl_user).new(common_params)
    expect(resource).not_to be_nil
    expect(resource.parameters[:linger].value).to eq(:disabled)
  end

  it 'enables linger when requested' do
    resource = Puppet::Type.type(:loginctl_user).new(common_params.merge(linger: 'enabled'))
    expect(resource).not_to be_nil
    expect(resource.parameters[:linger].value).to eq(:enabled)
  end
end
