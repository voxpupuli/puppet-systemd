require 'spec_helper'

describe 'systemd::systemctl::daemon_reload' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'test1' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_exec("systemctl-daemon-reload # #{title}") }
      end
    end
  end
end
