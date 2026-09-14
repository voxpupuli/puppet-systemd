# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::journald::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:title) { 'test.conf' }
        let(:params) do
          {
            journal_entry: {
              'Storage' => 'persistent',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/systemd/journald.conf.d/test.conf')
            .with_content(<<~EOF,
              # This file is managed with puppet
              #
              [Journal]
              Storage=persistent
            EOF
                         )
        }

        context 'with comments defined' do
          let(:params) { super().merge(comments: %w[test comment]) }

          it {
            is_expected.to contain_file('/etc/systemd/journald.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                # test
                # comment
                #
                [Journal]
                Storage=persistent
              EOF
                           )
          }
        end

        context 'with owner defined' do
          let(:params) { super().merge(owner: 'testuser') }

          it { is_expected.to contain_file('/etc/systemd/journald.conf.d/test.conf').with_owner('testuser') }
        end

        context 'with group defined' do
          let(:params) { super().merge(group: 'testgroup') }

          it { is_expected.to contain_file('/etc/systemd/journald.conf.d/test.conf').with_group('testgroup') }
        end

        context 'with mode defined' do
          let(:params) { super().merge(mode: '0644') }

          it { is_expected.to contain_file('/etc/systemd/journald.conf.d/test.conf').with_mode('0644') }
        end

        context 'with invalid journal_entry defined' do
          let(:params) { { journal_entry: { 'foo' => 'bar' } } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'journal_entry' unrecognized key}) }
        end

        context 'with an absent setting' do
          let(:params) do
            {
              journal_entry: {
                'Storage' => { 'ensure' => 'absent' },
                'Compress' => 'yes',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/journald.conf.d/test.conf')
              .with_content(<<~EOF,
                # This file is managed with puppet
                #
                [Journal]
                Compress=yes
              EOF
                           )
          }
        end

        context 'with ensure set to absent' do
          let(:params) { super().merge(ensure: 'absent') }

          it { is_expected.to contain_file('/etc/systemd/journald.conf.d/test.conf').with_ensure('absent') }
        end
      end
    end
  end
end
