# frozen_string_literal: true

require 'spec_helper'
describe 'systemd::systemctl_user' do
  context 'with old systemd' do
    let(:facts) do
      { systemd_version: '222' }
    end

    context 'with valid input' do
      it {
        is_expected.to run.with_params('foo', ['status', 'my.service']).and_return(
          [
            'runuser', '-u', 'foo', '--', '/usr/bin/bash', '-c',
            'env XDG_RUNTIME_DIR=/run/user/$(id -u) /usr/bin/systemctl --user status my.service'
          ]
        )
      }

      it {
        is_expected.to run.with_params('foo', ['is-enabled', 'my.service']).and_return(
          [
            'runuser', '-u', 'foo', '--', '/usr/bin/bash', '-c',
            'env XDG_RUNTIME_DIR=/run/user/$(id -u) /usr/bin/systemctl --user is-enabled my.service'
          ]
        )
      }
    end
  end

  context 'with new systemd' do
    let(:facts) do
      { systemd_version: '256' }
    end

    context 'with valid input' do
      it {
        is_expected.to run.with_params('foo', ['status', 'my.service']).and_return(
          ['run0', '--user', 'foo', '/usr/bin/systemctl', '--user', 'status', 'my.service']
        )
      }

      it {
        is_expected.to run.with_params('foo', ['is-enabled', 'my.service']).and_return(
          ['run0', '--user', 'foo', '/usr/bin/systemctl', '--user', 'is-enabled', 'my.service']
        )
      }
    end
  end

  context 'with invalid input' do
    it { is_expected.not_to run.with_params('foo') }
    it { is_expected.not_to run.with_params('foo', 'bar') }
  end
end
