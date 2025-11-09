# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::sysusers' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/etc/sysusers.d').with(
            {
              ensure: 'directory',
              owner: 'root',
              group: 'root',
              mode: '0755',
              purge: true,
              recurse: true,
              force: true,
            }
          )
        }

        it { is_expected.to contain_exec('systemd-sysusers').with_command('systemd-sysusers') }

        context 'with purgedir false' do
          let(:params) do
            { purgedir: false }
          end

          it {
            is_expected.to contain_file('/etc/sysusers.d').with(
              {
                ensure: 'directory',
                owner: 'root',
                group: 'root',
                mode: '0755',
                purge: false,
                recurse: false,
                force: false,
              }
            )
          }
        end
      end
    end
  end
end
