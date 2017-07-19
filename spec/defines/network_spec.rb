require 'spec_helper'

describe 'systemd::network' do
  let :params do
    {
      restart_service: true
    }
  end

  let(:title) { 'eth0.network' }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context 'with all defaults' do
      it { is_expected.to compile.with_all_deps }
    end
  end
end
