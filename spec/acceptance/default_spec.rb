# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'systemd' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include systemd
      PUPPET
    end
  end
end
