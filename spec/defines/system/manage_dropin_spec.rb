# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::system::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'systemd::daemon_reexec { "system.conf": }' }
        let(:title) { 'test.conf' }
        let(:params) do
          {
            system_entry: {
              'DefaultTimeoutStartSec' => '30s',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/system.conf.d/test.conf')
            .with_content(<<~EOF,
              # This file is managed with puppet
              #
              [Manager]
              DefaultTimeoutStartSec=30s
            EOF
                         )
        }

        context 'with multiple settings' do
          let(:params) do
            {
              system_entry: {
                'DefaultTimeoutStartSec' => '30s',
                'DefaultTimeoutStopSec' => '30s',
                'DefaultRestartSec' => '100ms',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/system.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Manager]
                DefaultTimeoutStartSec=30s
                DefaultTimeoutStopSec=30s
                DefaultRestartSec=100ms
              EOF
                           )
          }
        end

        context 'with owner defined' do
          let(:params) { super().merge(owner: 'testuser') }

          it { is_expected.to contain_file('/etc/systemd/system.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { super().merge(group: 'testgroup') }

          it { is_expected.to contain_file('/etc/systemd/system.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { super().merge(mode: '0600') }

          it { is_expected.to contain_file('/etc/systemd/system.conf.d/test.conf').with_mode('0600') }
        end

        context 'with invalid system_entry defined' do
          let(:params) { { system_entry: { 'foo' => 'bar' } } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'system_entry' unrecognized key}) }
        end

        context 'with an absent setting' do
          let(:params) do
            {
              system_entry: {
                'DefaultTimeoutStartSec' => { 'ensure' => 'absent' },
                'DefaultTimeoutStopSec' => '30s',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/system.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Manager]
                DefaultTimeoutStopSec=30s
              EOF
                           )
          }
        end

        context 'with ensure set to absent' do
          let(:params) { super().merge(ensure: 'absent') }

          it { is_expected.to contain_file('/etc/systemd/system.conf.d/test.conf').with_ensure('absent') }
        end

        context 'with comments' do
          let(:params) { super().merge(comments: ['a test', 'comment']) }

          it {
            is_expected.to contain_file('/etc/systemd/system.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                # a test
                # comment
                #
                [Manager]
                DefaultTimeoutStartSec=30s
              EOF
                           )
          }
        end
      end
    end
  end
end
