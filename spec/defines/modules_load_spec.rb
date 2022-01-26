# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::modules_load' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:title) { 'random_module.conf' }
        let(:params) { { content: 'random stuff' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_systemd__modules_load('random_module.conf') }

        it { is_expected.to contain_file('/etc/modules-load.d/random_module.conf') }

        it {
          is_expected.to contain_file('/etc/modules-load.d/random_module.conf').with

          {
            ensure: 'file',
            content: 'random stuff',
            mode: '0444'
          }
        }

        it { is_expected.to contain_class('systemd::modules_loads') }
        it { is_expected.to contain_exec('systemd-modules-load').with_command('systemctl start systemd-modules-load.service') }

        context 'with a bad modules-load name' do
          let(:title) { 'test.badtype' }

          it {
            is_expected.to compile.and_raise_error(%r{expects a match for Systemd::Dropin})
          }
        end
      end
    end
  end
end
