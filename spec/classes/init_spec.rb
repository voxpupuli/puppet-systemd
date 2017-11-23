require 'spec_helper'

describe 'systemd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('systemd') }
        it { is_expected.to create_class('systemd::systemctl::daemon_reload') }
        it { is_expected.to_not create_service('systemd-resolved') }
        it { is_expected.to_not create_service('systemd-networkd') }
        it { is_expected.to_not create_service('systemd-timesyncd') }

        context 'when enabling resolved and networkd' do
          let(:params) {{
            :manage_resolved => true,
            :manage_networkd => true
          }}

          it { is_expected.to create_service('systemd-resolved').with_ensure('running') }
          it { is_expected.to create_service('systemd-resolved').with_enable(true) }
          it { is_expected.to create_service('systemd-networkd').with_ensure('running') }
          it { is_expected.to create_service('systemd-networkd').with_enable(true) }
        end
        context 'when enabling timesyncd' do
          let(:params) {{
            :manage_timesyncd => true
          }}

          it { is_expected.to create_service('systemd-timesyncd').with_ensure('running') }
          it { is_expected.to create_service('systemd-timesyncd').with_enable(true) }
          it { is_expected.not_to create_service('systemd-resolved').with_ensure('running') }
          it { is_expected.not_to create_service('systemd-resolved').with_enable(true) }
          it { is_expected.not_to create_service('systemd-networkd').with_ensure('running') }
          it { is_expected.not_to create_service('systemd-networkd').with_enable(true) }
        end

        context 'when enabling timesyncd with NTP values (string)' do
          let(:params) {{
            :manage_timesyncd => true,
            :ntp_server => '0.pool.ntp.org 1.pool.ntp.org',
            :fallback_ntp_server => '2.pool.ntp.org 3.pool.ntp.org'
          }}
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_ini_setting('ntp_server')}
          it { is_expected.to contain_ini_setting('fallback_ntp_server')}
        end

        context 'when enabling timesyncd with NTP values (array)' do
          let(:params) {{
            :manage_timesyncd => true,
            :ntp_server => %w(0.pool.ntp.org 1.pool.ntp.org),
            :fallback_ntp_server => %w(2.pool.ntp.org 3.pool.ntp.org)
          }}
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_ini_setting('ntp_server')}
          it { is_expected.to contain_ini_setting('fallback_ntp_server')}
        end

        context 'when passing service limits' do
          let(:params) {{
            :service_limits => {'openstack-nova-compute.service' => {'limits' => {'LimitNOFILE' => 32768}}}
          }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__service_limits('openstack-nova-compute.service').with_limits({'LimitNOFILE' => 32768}) }
        end
      end
    end
  end
end
