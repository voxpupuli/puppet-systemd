require 'spec_helper'

describe 'systemd::mail_on_failure' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os} with default params" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('systemd::mail_on_failure') }
        it {
          is_expected.to contain_file('/usr/local/bin/systemd-email').with(
            content: %r{sendmail},
            owner: 'root',
            group: 'systemd-journal',
            mode: '0750',
          )
        }
        # for some reason facts['networking']['fqdn'] is not valid
        it { is_expected.to contain_systemd__unit_file('status_email_root@.service').with_content(%r{root@%H}) }
        it { is_expected.to contain_systemd__unit_file('status_email_root@.service').that_requires('File[/usr/local/bin/systemd-email]') }
      end
      context "on #{os} with params" do
        let(:facts) { facts }
        let(:params) { { email_users: ['root', 'admin', 'monitoring@example.com'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('systemd::mail_on_failure') }
        it {
          is_expected.to contain_file('/usr/local/bin/systemd-email').with(
            content: %r{sendmail},
            owner: 'root',
            group: 'systemd-journal',
            mode: '0750',
          )
        }
        it { is_expected.to contain_systemd__unit_file('status_email_root@.service').with_content(%r{root@%H}) }
        it { is_expected.to contain_systemd__unit_file('status_email_root@.service').that_requires('File[/usr/local/bin/systemd-email]') }
        it { is_expected.to contain_systemd__unit_file('status_email_admin@.service').with_content(%r{admin@%H}) }
        it { is_expected.to contain_systemd__unit_file('status_email_admin@.service').that_requires('File[/usr/local/bin/systemd-email]') }
        it { is_expected.to contain_systemd__unit_file('status_email_monitoring_AT_example.com@.service').with_content(%r{monitoring@example.com}) }
        it { is_expected.to contain_systemd__unit_file('status_email_monitoring_AT_example.com@.service').that_requires('File[/usr/local/bin/systemd-email]') }
      end
    end
  end
end
