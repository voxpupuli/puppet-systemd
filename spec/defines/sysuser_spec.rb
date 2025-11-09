# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::sysuser' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts.merge(systemd_version: '251') }
        let(:title) { 'random_sysusers.conf' }
        let(:params) { { content: 'random stuff' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('systemd::sysusers') }

        it {
          expect(subject).to create_file('/etc/sysusers.d/random_sysusers.conf').with(
            ensure: 'file',
            content: 'random stuff',
            validate_cmd: '/usr/bin/systemd-sysusers --dry-run %',
            mode: '0444'
          )
        }

        context 'with old systemd' do
          let(:facts) do
            super().merge(systemd_version: '247')
          end

          it {
            expect(subject).to create_file('/etc/sysusers.d/random_sysusers.conf').without_validate
          }
        end

        context 'with validate false' do
          let(:facts) { facts.merge(systemd_version: '251') }
          let(:params) do
            super().merge(validate: false)
          end

          it {
            expect(subject).to create_file('/etc/sysusers.d/random_sysusers.conf').without_validate
          }
        end

        context 'with a bad sysusers name' do
          let(:title) { 'test.badtype' }

          it {
            expect do
              expect(subject).to compile.with_all_deps
            end.to raise_error(%r{expects a match for Systemd::Dropin})
          }
        end

        context 'with a bad sysuser name with slash' do
          let(:title) { 'test/foo.conf' }

          it {
            expect do
              expect(subject).to compile.with_all_deps
            end.to raise_error(%r{expects a match for Systemd::Dropin})
          }
        end

        context 'with a sysuser name specified with filename' do
          let(:title) { 'test.badtype' }
          let(:params) do
            {
              filename: 'goodname.conf',
              content: 'random stuff',
            }
          end

          it {
            expect(subject).to create_file('/etc/sysusers.d/goodname.conf').with(
              ensure: 'file',
              content: 'random stuff',
              mode: '0444'
            )
          }
        end
      end
    end
  end
end
