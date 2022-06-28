# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Unit' do
  it { is_expected.to allow_value({ 'Description' => 'special' }) }
  it { is_expected.to allow_value({ 'Description' => '' }) }
  it { is_expected.to allow_value({ 'Description' => [''] }) }
  it { is_expected.to allow_value({ 'Description' => %w[my special] }) }
  it { is_expected.to allow_value({ 'Description' => ['', 'special'] }) }

  it { is_expected.to allow_value({ 'Documentation' => 'special' }) }
  it { is_expected.to allow_value({ 'Documentation' => '' }) }
  it { is_expected.to allow_value({ 'Documentation' => [''] }) }
  it { is_expected.to allow_value({ 'Documentation' => %w[my special] }) }
  it { is_expected.to allow_value({ 'Documentation' => ['', 'special'] }) }

  %w[Wants Requires Requisite Wants PartOf Upholds Conflicts Before After OnFailure OnSuccess].each do |depend|
    context "with a key of #{depend} can have values of units" do
      it { is_expected.to allow_value({ depend.to_s => 'foobar.service' }) }
      it { is_expected.to allow_value({ depend.to_s => ['foobar.service'] }) }
      it { is_expected.to allow_value({ depend.to_s => ['alpha.service', 'beta.service'] }) }
      it { is_expected.to allow_value({ depend.to_s => '' }) }
      it { is_expected.to allow_value({ depend.to_s => [''] }) }
      it { is_expected.to allow_value({ depend.to_s => ['', 'foobar.service'] }) }
    end
  end

  %w[ConditionPathExists ConditionPathIsDirectory AssertPathExists AssertPathIsDirectory].each do |assert|
    context "with a key of #{assert} can have files or negated files" do
      it { is_expected.to allow_value({ assert.to_s => '/my/existing/file' }) }
      it { is_expected.to allow_value({ assert.to_s => '!/my/existing/file' }) }
      it { is_expected.to allow_value({ assert.to_s => '' }) }
      it { is_expected.to allow_value({ assert.to_s => ['', '/my/existing/file', '!/my/non/existing/file'] }) }
    end
  end

  it { is_expected.not_to allow_value({ 'Description' => 10 }) }
  it { is_expected.not_to allow_value({ 'Wants' => '/unitwith.service' }) }

  it { is_expected.not_to allow_value({ 'Wants' => 'noextension' }) }
  it { is_expected.not_to allow_value({ 'Wants' => ['noextension'] }) }
  it { is_expected.not_to allow_value({ 'ConditionPathExists' => 'not/an/absolute/path' }) }
  it { is_expected.not_to allow_value({ 'ConditionPathExists' => ['not/an/absolute/path'] }) }
end
