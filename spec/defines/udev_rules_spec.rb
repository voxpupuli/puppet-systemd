# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::udev::rule' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'test.rules' }

        let(:pre_condition) do
          <<-PUPPET
          class { 'systemd': manage_udevd => true, manage_journald => false }
          service { 'foo': }
          PUPPET
        end

        describe 'with all options (one notify)' do
          let(:params) do
            {
              ensure: 'file',
              path: '/etc/udev/rules.d',
              selinux_ignore_defaults: false,
              notify_services: 'Service[systemd-udevd]',
              rules: [
                '# I am a comment',
                'ACTION=="add", KERNEL=="sda", RUN+="/bin/raw /dev/raw/raw1 %N"',
                'ACTION=="add", KERNEL=="sdb", RUN+="/bin/raw /dev/raw/raw2 %N"',
              ],
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to create_file("/etc/udev/rules.d/#{title}").
              with(ensure: 'file', mode: '0444', owner: 'root', group: 'root').
              with_content(%r{^# This file managed by Puppet - DO NOT EDIT$}).
              with_content(%r{^# I am a comment$}).
              with_content(%r{^ACTION=="add", KERNEL=="sda", RUN\+="/bin/raw /dev/raw/raw1 %N"$}).
              with_content(%r{^ACTION=="add", KERNEL=="sdb", RUN\+="/bin/raw /dev/raw/raw2 %N"$}).
              that_notifies('Service[systemd-udevd]')
          }

          it { is_expected.to contain_class('systemd') }
          it { is_expected.to contain_class('systemd::install') }
          it { is_expected.to contain_class('systemd::udevd') }
          it { is_expected.to contain_service('systemd-udevd') }
          it { is_expected.to contain_file('/etc/udev/udev.conf') }
        end

        describe 'with all options (array notify)' do
          let(:params) do
            {
              ensure: 'file',
              path: '/etc/udev/rules.d',
              selinux_ignore_defaults: false,
              notify_services: ['Service[systemd-udevd]', 'Service[foo]'],
              rules: [
                '# I am a comment',
                'ACTION=="add", KERNEL=="sda", RUN+="/bin/raw /dev/raw/raw1 %N"',
                'ACTION=="add", KERNEL=="sdb", RUN+="/bin/raw /dev/raw/raw2 %N"',
              ],
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to create_file("/etc/udev/rules.d/#{title}").
              with(ensure: 'file', mode: '0444', owner: 'root', group: 'root').
              with_content(%r{^# This file managed by Puppet - DO NOT EDIT$}).
              with_content(%r{^# I am a comment$}).
              with_content(%r{^ACTION=="add", KERNEL=="sda", RUN\+="/bin/raw /dev/raw/raw1 %N"$}).
              with_content(%r{^ACTION=="add", KERNEL=="sdb", RUN\+="/bin/raw /dev/raw/raw2 %N"$}).
              that_notifies('Service[systemd-udevd]').
              that_notifies('Service[foo]')
          }
        end

        describe 'ensured absent without notify' do
          let(:params) { { ensure: 'absent', } }

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_file("/etc/udev/rules.d/#{title}").with_ensure('absent').with_notify([]) }
        end

        describe 'ensured absent with notify' do
          let(:params) { { ensure: 'absent', notify_services: 'Service[systemd-udevd]', } }

          it { is_expected.to compile.with_all_deps }

          it do
            is_expected.to create_file("/etc/udev/rules.d/#{title}").
              with_ensure('absent').
              that_notifies('Service[systemd-udevd]')
          end
        end
      end
    end
  end
end
