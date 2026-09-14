# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::logind::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'class { "systemd": manage_logind => true }' }
        let(:title) { 'test.conf' }
        let(:params) do
          {
            logind_entry: {
              'NAutoVTs' => 4,
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/logind.conf.d/test.conf')
            .with_content(<<~EOF,
              # This file is managed with puppet
              #
              [Login]
              NAutoVTs=4
            EOF
                         )
        }

        context 'with multiple settings' do
          let(:params) do
            {
              comments: ['a test', 'comment'],
              logind_entry: {
                'NAutoVTs' => 6,
                'HandlePowerKey' => 'poweroff',
                'HandleSuspendKey' => 'suspend',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/logind.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                # a test
                # comment
                #
                [Login]
                NAutoVTs=6
                HandlePowerKey=poweroff
                HandleSuspendKey=suspend
              EOF
                           )
          }
        end

        context 'with owner defined' do
          let(:params) { super().merge(owner: 'testuser') }

          it { is_expected.to contain_file('/etc/systemd/logind.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { super().merge(group: 'testgroup') }

          it { is_expected.to contain_file('/etc/systemd/logind.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { super().merge(mode: '0600') }

          it { is_expected.to contain_file('/etc/systemd/logind.conf.d/test.conf').with_mode('0600') }
        end

        context 'with invalid logind_entry defined' do
          let(:params) { { logind_entry: { 'foo' => 'bar' } } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'logind_entry' unrecognized key}) }
        end

        context 'with an absent setting' do
          let(:params) do
            {
              logind_entry: {
                'NAutoVTs' => { 'ensure' => 'absent' },
                'HandlePowerKey' => 'poweroff',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/logind.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Login]
                HandlePowerKey=poweroff
              EOF
                           )
          }
        end

        context 'with ensure set to absent' do
          let(:params) { super().merge(ensure: 'absent') }

          it { is_expected.to contain_file('/etc/systemd/logind.conf.d/test.conf').with_ensure('absent') }
        end
      end
    end
  end
end
