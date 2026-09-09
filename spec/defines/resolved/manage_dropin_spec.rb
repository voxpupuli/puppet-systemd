# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::resolved::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'class { "systemd": manage_resolved => true }' }
        let(:title) { 'test.conf' }
        let(:params) do
          {
            resolved_entry: {
              'DNS' => '8.8.8.8',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/resolved.conf.d/test.conf')
            .with_content(<<~EOF,
              # This file is managed with puppet
              #
              [Resolve]
              DNS=8.8.8.8
            EOF
                         )
        }

        context 'with multiple settings' do
          let(:params) do
            {
              resolved_entry: {
                'DNS' => '8.8.8.8 8.8.4.4',
                'FallbackDNS' => '1.1.1.1',
                'DNSSEC' => 'no',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/resolved.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Resolve]
                DNS=8.8.8.8 8.8.4.4
                FallbackDNS=1.1.1.1
                DNSSEC=no
              EOF
                           )
          }
        end

        context 'with owner defined' do
          let(:params) { super().merge(owner: 'testuser') }

          it { is_expected.to contain_file('/etc/systemd/resolved.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { super().merge(group: 'testgroup') }

          it { is_expected.to contain_file('/etc/systemd/resolved.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { super().merge(mode: '0600') }

          it { is_expected.to contain_file('/etc/systemd/resolved.conf.d/test.conf').with_mode('0600') }
        end

        context 'with an absent setting' do
          let(:params) do
            {
              resolved_entry: {
                'DNS' => { 'ensure' => 'absent' },
                'FallbackDNS' => '1.1.1.1',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/resolved.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Resolve]
                FallbackDNS=1.1.1.1
              EOF
                           )
          }
        end

        context 'with ensure set to absent' do
          let(:params) { super().merge(ensure: 'absent') }

          it { is_expected.to contain_file('/etc/systemd/resolved.conf.d/test.conf').with_ensure('absent') }
        end

        context 'with comments' do
          let(:params) { super().merge(comments: ['a test', 'comment']) }

          it {
            is_expected.to contain_file('/etc/systemd/resolved.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                # a test
                # comment
                #
                [Resolve]
                DNS=8.8.8.8
              EOF
                           )
          }
        end
      end
    end
  end
end
