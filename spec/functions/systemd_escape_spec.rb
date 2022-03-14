# frozen_string_literal: true

require 'spec_helper'
describe 'systemd::systemd_escape' do
  context 'with path false' do
    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['abcöäüß']]], { combine: false, failonfail: true }).and_return("abc\\xc3\\xb6\\xc3\\xa4\\xc3\\xbc\\xc3\\x9f\n")

      is_expected.to run.with_params('abcöäüß', false).and_return('abc\xc3\xb6\xc3\xa4\xc3\xbc\xc3\x9f')
    end
  end

  context 'with path true' do
    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path abcöäüß]]], { combine: false, failonfail: true }).and_return("abc\\xc3\\xb6\\xc3\\xa4\\xc3\\xbc\\xc3\\x9f\n")

      is_expected.to run.with_params('abcöäüß', true).and_return('abc\xc3\xb6\xc3\xa4\xc3\xbc\xc3\x9f')
    end
  end
end
