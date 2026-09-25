# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::timesyncd::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'class { "systemd": manage_timesyncd => true }' }
        let(:title) { 'test.conf' }
        let(:params) do
          {
            timesyncd_entry: {
              'NTP' => 'pool.ntp.org',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf')
            .with_content(<<~EOF,
              # This file is managed with puppet
              #
              [Time]
              NTP=pool.ntp.org
            EOF
                         )
        }

        context 'with multiple settings' do
          let(:params) do
            {
              timesyncd_entry: {
                'NTP' => 'pool.ntp.org',
                'FallbackNTP' => '0.debian.pool.ntp.org',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Time]
                NTP=pool.ntp.org
                FallbackNTP=0.debian.pool.ntp.org
              EOF
                           )
          }
        end

        context 'with owner defined' do
          let(:params) { super().merge(owner: 'testuser') }

          it { is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { super().merge(group: 'testgroup') }

          it { is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { super().merge(mode: '0600') }

          it { is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf').with_mode('0600') }
        end

        context 'with an absent setting' do
          let(:params) do
            {
              timesyncd_entry: {
                'NTP' => { 'ensure' => 'absent' },
                'FallbackNTP' => '0.debian.pool.ntp.org',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Time]
                FallbackNTP=0.debian.pool.ntp.org
              EOF
                           )
          }
        end

        context 'with ensure set to absent' do
          let(:params) { super().merge(ensure: 'absent') }

          it { is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf').with_ensure('absent') }
        end

        context 'with comments' do
          let(:params) { super().merge(comments: ['a test', 'comment']) }

          it {
            is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                # a test
                # comment
                #
                [Time]
                NTP=pool.ntp.org
              EOF
                           )
          }
        end
      end
    end
  end
end
