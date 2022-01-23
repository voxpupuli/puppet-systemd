# frozen_string_literal: true

require 'spec_helper'
describe 'systemd::systemd_escape' do
  context 'with path false' do
    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['foo']]], { combine: false, failonfail: true }).and_return("foo\n")

      is_expected.to run.with_params('foo', false).and_return('foo')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['foo/bar/.']]], { combine: false, failonfail: true }).and_return("foo-bar-.\n")

      is_expected.to run.with_params('foo/bar/.', false).and_return('foo-bar-.')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['/foo/bar/']]], { combine: false, failonfail: true }).and_return("-foo-bar-\n")

      is_expected.to run.with_params('/foo/bar/', false).and_return('-foo-bar-')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['//foo//bar//']]], { combine: false, failonfail: true }).and_return("--foo--bar--\n")

      is_expected.to run.with_params('//foo//bar//', false).and_return('--foo--bar--')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['//foo//bar-baz//']]], { combine: false, failonfail: true }).and_return("--foo--bar\\x2dbaz--\n")

      is_expected.to run.with_params('//foo//bar-baz//', false).and_return('--foo--bar\x2dbaz--')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['//foo:bar,foo_bar.//']]], { combine: false, failonfail: true }).and_return("--foo:bar\\x2cfoo_bar.--\n")

      is_expected.to run.with_params('//foo:bar,foo_bar.//', false).and_return('--foo:bar\x2cfoo_bar.--')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['.foo']]], { combine: false, failonfail: true }).and_return("\\x2efoo\n")

      is_expected.to run.with_params('.foo', false).and_return('\x2efoo')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [['abcöäüß']]], { combine: false, failonfail: true }).and_return("abc\\xc3\\xb6\\xc3\\xa4\\xc3\\xbc\\xc3\\x9f\n")

      is_expected.to run.with_params('abcöäüß', false).and_return('abc\xc3\xb6\xc3\xa4\xc3\xbc\xc3\x9f')
    end
  end

  context 'with path true' do
    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path foo]]], { combine: false, failonfail: true }).and_return("foo\n")

      is_expected.to run.with_params('foo', true).and_return('foo')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path foo/bar/.]]], { combine: false, failonfail: true }).and_raise(Puppet::ExecutionFailure, "Execution of 'systemd-escape --path foo/bar/.' returned 1: ")

      is_expected.to run.with_params('foo/bar/.', true).and_raise_error(Puppet::ExecutionFailure, %r{Execution of 'systemd-escape --path foo/bar/.' returned 1: })
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path /foo/bar/]]], { combine: false, failonfail: true }).and_return("foo-bar\n")

      is_expected.to run.with_params('/foo/bar/', true).and_return('foo-bar')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path //foo//bar//]]], { combine: false, failonfail: true }).and_return("foo-bar\n")

      is_expected.to run.with_params('//foo//bar//', true).and_return('foo-bar')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path //foo//bar-baz//]]], { combine: false, failonfail: true }).and_return("foo-bar\\x2dbaz\n")

      is_expected.to run.with_params('//foo//bar-baz//', true).and_return('foo-bar\x2dbaz')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path //foo:bar,foo_bar.//]]], { combine: false, failonfail: true }).and_return("foo:bar\\x2cfoo_bar.\n")

      is_expected.to run.with_params('//foo:bar,foo_bar.//', true).and_return('foo:bar\x2cfoo_bar.')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path .foo]]], { combine: false, failonfail: true }).and_return("\\x2efoo\n")

      is_expected.to run.with_params('.foo', true).and_return('\x2efoo')
    end

    it do
      allow(Puppet::Util::Execution).to receive(:execute).with(['systemd-escape', [%w[--path abcöäüß]]], { combine: false, failonfail: true }).and_return("abc\\xc3\\xb6\\xc3\\xa4\\xc3\\xbc\\xc3\\x9f\n")

      is_expected.to run.with_params('abcöäüß', true).and_return('abc\xc3\xb6\xc3\xa4\xc3\xbc\xc3\x9f')
    end
  end
end
