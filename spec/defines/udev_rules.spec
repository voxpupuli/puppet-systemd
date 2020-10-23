require 'spec_helper'

describe 'systemd::udev::rule' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'test.rules' }

        describe 'with all options (one notify)' do
          let(:params) do
            {
              ensure: 'present',
              path: '/etc/udev/rules.d',
              selinux_ignore_defaults: false,
              notify_services: "Service['systemd-udevd']",
              rules: [
                '# I am a comment',
                'ACTION=="add", KERNEL=="sda", RUN+="/bin/raw /dev/raw/raw1 %N"',
                'ACTION=="add", KERNEL=="sdb", RUN+="/bin/raw /dev/raw/raw2 %N"',
              ],
            }
          end

          it { is_expected.to compile.with_all_deps }
          it {
            is_expected.to create_file("/etc/udev/rules.d/#{title}")
              .with(ensure: 'file', mode: '0444', owner: 'root', group: 'root')
              .with_content(%r{^# I am a comment$})
              .with_content(%r{^ACTION=="add", KERNEL=="sda", RUN+="/bin/raw /dev/raw/raw1 %N"$})
              .with_content(%r{^ACTION=="add", KERNEL=="sdb", RUN+="/bin/raw /dev/raw/raw2 %N"$})
              .that_notifies("Service['systemd-udevd']")
          }
        end

        describe 'with all options (array notify)' do
          let(:params) do
            {
              ensure: 'present',
              path: '/etc/udev/rules.d',
              selinux_ignore_defaults: false,
              notify_services: ["Service['systemd-udevd']", "Service['foo']"],
              rules: [
                '# I am a comment',
                'ACTION=="add", KERNEL=="sda", RUN+="/bin/raw /dev/raw/raw1 %N"',
                'ACTION=="add", KERNEL=="sdb", RUN+="/bin/raw /dev/raw/raw2 %N"',
              ],
            }
          end

          it { is_expected.to compile.with_all_deps }
          it {
            is_expected.to create_file("/etc/udev/rules.d/#{title}")
              .with(ensure: 'file', mode: '0444', owner: 'root', group: 'root')
              .with_content(%r{^# I am a comment$})
              .with_content(%r{^ACTION=="add", KERNEL=="sda", RUN+="/bin/raw /dev/raw/raw1 %N"$})
              .with_content(%r{^ACTION=="add", KERNEL=="sdb", RUN+="/bin/raw /dev/raw/raw2 %N"$})
              .that_notifies("Service['systemd-udevd']")
              .that_notifies("Service['foo']")
          }
        end

        describe 'ensured absent' do
          let(:params) { { ensure: 'absent' } }

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to create_file("/etc/udev/rules.d/#{title}")
              .with_ensure('absent')
              .that_notifies("Service['systemd-udevd']")
          end
        end
      end
    end
  end
end
