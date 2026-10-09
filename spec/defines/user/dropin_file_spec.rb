# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::user::dropin_file' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'systemd::daemon_reexec { "user.conf": }' }
        let(:title) { 'test.conf' }

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/user.conf.d')
            .with_ensure('directory')
            .with_recurse(false)
            .with_purge(false)
        }

        it {
          is_expected.to contain_file('/etc/systemd/user.conf.d/test.conf')
            .with_ensure('file')
            .with_owner('root')
            .with_group('root')
            .with_mode('0644')
        }

        context 'with custom content' do
          let(:params) do
            {
              content: "# Test\n[Manager]\nDefaultTimeoutStartSec=20s\n",
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/user.conf.d/test.conf')
              .with_content("# Test\n[Manager]\nDefaultTimeoutStartSec=20s\n")
          }
        end

        context 'with owner defined' do
          let(:params) { { owner: 'testuser' } }

          it { is_expected.to contain_file('/etc/systemd/user.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { { group: 'testgroup' } }

          it { is_expected.to contain_file('/etc/systemd/user.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { { mode: '0600' } }

          it { is_expected.to contain_file('/etc/systemd/user.conf.d/test.conf').with_mode('0600') }
        end

        context 'with notify_user set to false' do
          let(:params) { { notify_user: false } }

          it { is_expected.to compile.with_all_deps }
        end

        context 'with ensure set to absent' do
          let(:params) { { ensure: 'absent' } }

          it { is_expected.to contain_file('/etc/systemd/user.conf.d/test.conf').with_ensure('absent') }
        end

        context 'with purge_dropin_dirs set to true' do
          let(:pre_condition) do
            [
              'systemd::daemon_reexec { "user.conf": }',
              'class { "systemd": user_purge_dropin_dirs => true }',
            ].join("\n")
          end

          it {
            is_expected.to contain_file('/etc/systemd/user.conf.d/')
              .with_purge(true)
              .with_recurse(true)
          }
        end
      end
    end
  end
end
