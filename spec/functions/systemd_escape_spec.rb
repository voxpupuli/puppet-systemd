# frozen_string_literal: true

require 'spec_helper'
describe 'systemd::systemd_escape' do
  context 'with path false' do
    it { is_expected.to run.with_params('foo', false).and_return('foo') }
    it { is_expected.to run.with_params('foo/bar/.', false).and_return('foo-bar-.') }
    it { is_expected.to run.with_params('/foo/bar/', false).and_return('-foo-bar-') }
    it { is_expected.to run.with_params('//foo//bar//', false).and_return('--foo--bar--') }
    it { is_expected.to run.with_params('//foo//bar-baz//', false).and_return('--foo--bar\x2dbaz--') }
    it { is_expected.to run.with_params('//foo:bar,foo_bar.//', false).and_return('--foo:bar\x2cfoo_bar.--') }
    it { is_expected.to run.with_params('.foo', false).and_return('\x2efoo') }
    it { is_expected.to run.with_params('abcöäüß', false).and_return('abc\xc3\xb6\xc3\xa4\xc3\xbc\xc3\x9f') }
  end

  context 'with path true' do
    it { is_expected.to run.with_params('foo', true).and_return('foo') }
    it { is_expected.to run.with_params('foo/bar/.', true).and_raise_error(Puppet::ExecutionFailure, %r{Execution of 'systemd-escape --path foo/bar/.' returned 1: }) }
    it { is_expected.to run.with_params('/foo/bar/', true).and_return('foo-bar') }
    it { is_expected.to run.with_params('//foo//bar//', true).and_return('foo-bar') }
    it { is_expected.to run.with_params('//foo//bar-baz//', true).and_return('foo-bar\x2dbaz') }
    it { is_expected.to run.with_params('//foo:bar,foo_bar.//', true).and_return('foo:bar\x2cfoo_bar.') }
    it { is_expected.to run.with_params('.foo', true).and_return('\x2efoo') }
    it { is_expected.to run.with_params('abcöäüß', true).and_return('abc\xc3\xb6\xc3\xa4\xc3\xbc\xc3\x9f') }
  end
end
