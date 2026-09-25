# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::coredump::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'class { "systemd": manage_coredump => true }' }
        let(:title) { 'test.conf' }
        let(:params) do
          {
            coredump_entry: {
              'Storage' => 'external',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/coredump.conf.d/test.conf')
            .with_content(<<~EOF,
              # This file is managed with puppet
              #
              [Coredump]
              Storage=external
            EOF
                         )
        }

        context 'with multiple settings' do
          let(:params) do
            {
              coredump_entry: {
                'Storage' => 'journal',
                'Compress' => 'yes',
                'ProcessSizeMax' => '2G',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/coredump.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Coredump]
                Storage=journal
                Compress=yes
                ProcessSizeMax=2G
              EOF
                           )
          }
        end

        context 'with owner defined' do
          let(:params) { super().merge(owner: 'testuser') }

          it { is_expected.to contain_file('/etc/systemd/coredump.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { super().merge(group: 'testgroup') }

          it { is_expected.to contain_file('/etc/systemd/coredump.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { super().merge(mode: '0600') }

          it { is_expected.to contain_file('/etc/systemd/coredump.conf.d/test.conf').with_mode('0600') }
        end

        context 'with invalid coredump_entry defined' do
          let(:params) { { coredump_entry: { 'foo' => 'bar' } } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'coredump_entry' unrecognized key}) }
        end

        context 'with comments' do
          let(:params) { super().merge(comments: ['a test', 'comment']) }

          it {
            is_expected.to contain_file('/etc/systemd/coredump.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                # a test
                # comment
                #
                [Coredump]
                Storage=external
              EOF
                           )
          }
        end

        context 'with an absent setting' do
          let(:params) do
            {
              coredump_entry: {
                'Storage' => { 'ensure' => 'absent' },
                'Compress' => 'yes',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/coredump.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Coredump]
                Compress=yes
              EOF
                           )
          }
        end

        context 'with ensure set to absent' do
          let(:params) { super().merge(ensure: 'absent') }

          it { is_expected.to contain_file('/etc/systemd/coredump.conf.d/test.conf').with_ensure('absent') }
        end

        context 'with notify_coredump parameter (ignored)' do
          let(:params) { super().merge(notify_coredump: true) }

          # Should compile without triggering any service notify
          it { is_expected.to compile.with_all_deps }
          it { is_expected.not_to contain_service('systemd-coredump@') }
        end
      end
    end
  end
end
