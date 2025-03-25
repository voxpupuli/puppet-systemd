# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::networkd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) do
        [
          'include systemd',
          # Fake assert_private function from stdlib to not fail within this test
          'function assert_private () { }',
        ]
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
