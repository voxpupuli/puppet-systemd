# frozen_string_literal: true

require 'spec_helper'
describe 'systemd::escape' do
  context 'with path false' do
    it { is_expected.to run.with_params('foo', false).and_return('foo') }
    it { is_expected.to run.with_params('foo/bar/.', false).and_return('foo-bar-.') }
    it { is_expected.to run.with_params('/foo/bar/', false).and_return('-foo-bar-') }
    it { is_expected.to run.with_params('//foo//bar//', false).and_return('--foo--bar--') }
    it { is_expected.to run.with_params('//foo:bar,foo_bar.//', false).and_return('--foo:bar\x2cfoo_bar.--') }
    it { is_expected.to run.with_params('.foo', false).and_return('\x2efoo') }
    it { is_expected.to run.with_params('/foo/bar-baz/qux-quux', false).and_return('-foo-bar\x2dbaz-qux\x2dquux') }
  end

  context 'with path true' do
    it { is_expected.to run.with_params('foo', true).and_return('foo') }
    it { is_expected.to run.with_params('foo/bar/.', true).and_raise_error(%r{ path can not end}) }
    it { is_expected.to run.with_params('/foo/bar/', true).and_return('foo-bar') }
    it { is_expected.to run.with_params('//foo//bar//', true).and_return('foo-bar') }
    it { is_expected.to run.with_params('//foo:bar,foo_bar.//', true).and_return('foo:bar\x2cfoo_bar.') }
    it { is_expected.to run.with_params('.foo', true).and_return('\x2efoo') }
    it { is_expected.to run.with_params('/foo/bar-baz/qux-quux', true).and_return('foo-bar\x2dbaz-qux\x2dquux') }
  end
end
