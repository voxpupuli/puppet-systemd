require 'spec_helper'

describe 'systemd::unit_file' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'test.service' }

        let(:params) {{
          :content => 'random stuff'
        }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_file("/etc/systemd/system/#{title}").with(
          :ensure  => 'file',
          :content => /#{params[:content]}/,
          :mode    => '0644'
        ) }
        it { is_expected.to create_file("/etc/systemd/system/#{title}").that_notifies('Class[systemd::systemctl::daemon_reload]') }
      end
    end
  end
end
