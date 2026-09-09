# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::sleep::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'class { "systemd": manage_sleep => true }' }
        let(:title) { 'test.conf' }
        let(:params) do
          {
            sleep_entry: {
              'AllowSuspend' => 'yes',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/sleep.conf.d/test.conf')
            .with_content(<<~EOF,
              # This file is managed with puppet
              #
              [Sleep]
              AllowSuspend=yes
            EOF
                         )
        }

        context 'with multiple settings' do
          let(:params) do
            {
              sleep_entry: {
                'AllowSuspend' => 'no',
                'AllowHibernation' => 'yes',
                'AllowHybridSleep' => 'no',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/sleep.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Sleep]
                AllowSuspend=no
                AllowHibernation=yes
                AllowHybridSleep=no
              EOF
                           )
          }
        end

        context 'with owner defined' do
          let(:params) { super().merge(owner: 'testuser') }

          it { is_expected.to contain_file('/etc/systemd/sleep.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { super().merge(group: 'testgroup') }

          it { is_expected.to contain_file('/etc/systemd/sleep.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { super().merge(mode: '0600') }

          it { is_expected.to contain_file('/etc/systemd/sleep.conf.d/test.conf').with_mode('0600') }
        end

        context 'with invalid sleep_entry defined' do
          let(:params) { { sleep_entry: { 'foo' => 'bar' } } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'sleep_entry' unrecognized key}) }
        end

        context 'with comments' do
          let(:params) { super().merge(comments: ['a test', 'comment']) }

          it {
            is_expected.to contain_file('/etc/systemd/sleep.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                # a test
                # comment
                #
                [Sleep]
                AllowSuspend=yes
              EOF
                           )
          }
        end

        context 'with an absent setting' do
          let(:params) do
            {
              sleep_entry: {
                'AllowSuspend' => { 'ensure' => 'absent' },
                'AllowHibernation' => 'yes',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/sleep.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Sleep]
                AllowHibernation=yes
              EOF
                           )
          }
        end

        context 'with ensure set to absent' do
          let(:params) { super().merge(ensure: 'absent') }

          it { is_expected.to contain_file('/etc/systemd/sleep.conf.d/test.conf').with_ensure('absent') }
        end
      end
    end
  end
end
