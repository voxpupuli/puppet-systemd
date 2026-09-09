# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::timesyncd::dropin_file' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'class { "systemd": manage_timesyncd => true }' }
        let(:title) { 'test.conf' }

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/timesyncd.conf.d')
            .with_ensure('directory')
            .with_recurse(false)
            .with_purge(false)
        }

        it {
          is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf')
            .with_ensure('file')
            .with_owner('root')
            .with_group('root')
            .with_mode('0644')
        }

        it {
          is_expected.to contain_service('systemd-timesyncd')
            .that_subscribes_to('File[/etc/systemd/timesyncd.conf.d/test.conf]')
        }

        context 'with custom content' do
          let(:params) do
            {
              content: "# Test\n[Time]\nNTP=pool.ntp.org\n",
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf')
              .with_content("# Test\n[Time]\nNTP=pool.ntp.org\n")
          }
        end

        context 'with owner defined' do
          let(:params) { { owner: 'testuser' } }

          it { is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { { group: 'testgroup' } }

          it { is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { { mode: '0600' } }

          it { is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf').with_mode('0600') }
        end

        context 'with notify_timesyncd set to false' do
          let(:params) { { notify_timesyncd: false } }

          it { is_expected.not_to contain_service('systemd-timesyncd').that_subscribes_to('File[/etc/systemd/timesyncd.conf.d/test.conf]') }
        end

        context 'with ensure set to absent' do
          let(:params) { { ensure: 'absent' } }

          it { is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/test.conf').with_ensure('absent') }
        end

        context 'with purge_dropin_dirs set to true' do
          let(:pre_condition) { 'class { "systemd": manage_timesyncd => true, timesyncd_purge_dropin_dirs => true }' }

          it {
            is_expected.to contain_file('/etc/systemd/timesyncd.conf.d/')
              .with_purge(true)
              .with_recurse(true)
          }
        end

        context 'with systemd::manage_timesyncd set to false' do
          let(:pre_condition) { 'class { "systemd": manage_timesyncd => false }' }

          it { is_expected.to compile.and_raise_error(%r{systemd::timesyncd::dropin_file is disabled because systemd::manage_timesyncd is set to false}) }
        end
      end
    end
  end
end
