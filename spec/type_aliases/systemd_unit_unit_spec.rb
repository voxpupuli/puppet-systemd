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

  %w[Wants Requires Requisite BindsTo Wants PartOf Upholds Conflicts Before After OnFailure OnSuccess PropagatesReloadTo ReloadPropagatedFrom PropagatesStopTo StopPropagatedFrom JoinsNamespaceOf].each do |depend|
    context "with a key of #{depend} can have values of units" do
      it { is_expected.to allow_value({ depend.to_s => 'foobar.service' }) }
      it { is_expected.to allow_value({ depend.to_s => ['foobar.service'] }) }
      it { is_expected.to allow_value({ depend.to_s => ['alpha.service', 'beta.service'] }) }
      it { is_expected.to allow_value({ depend.to_s => '' }) }
      it { is_expected.to allow_value({ depend.to_s => [''] }) }
      it { is_expected.to allow_value({ depend.to_s => ['', 'foobar.service'] }) }
    end
  end

  # JobModes
  %w[OnSuccessJobMode OnFailureJobMode].each do |assert|
    context "with a key of #{assert} can have appropriate values" do
      it { is_expected.to allow_value({ assert.to_s => 'fail' }) }
      it { is_expected.to allow_value({ assert.to_s => 'replace' }) }
      it { is_expected.to allow_value({ assert.to_s => 'replace-irreversibly' }) }
      it { is_expected.to allow_value({ assert.to_s => 'isolate' }) }
      it { is_expected.to allow_value({ assert.to_s => 'flush' }) }
      it { is_expected.to allow_value({ assert.to_s => 'ignore-dependencies' }) }
      it { is_expected.to allow_value({ assert.to_s => 'ignore-requirements' }) }
      it { is_expected.not_to allow_value({ assert.to_s => '' }) }
      it { is_expected.not_to allow_value({ assert.to_s => 'some-other-mode' }) }
    end
  end

  # Actions
  %w[FailureAction SuccessAction].each do |assert|
    context "with a key of #{assert} can have appropriate values" do
      it { is_expected.to allow_value({ assert.to_s => 'none' }) }
      it { is_expected.to allow_value({ assert.to_s => 'reboot' }) }
      it { is_expected.to allow_value({ assert.to_s => 'reboot-force' }) }
      it { is_expected.to allow_value({ assert.to_s => 'reboot-immediate' }) }
      it { is_expected.to allow_value({ assert.to_s => 'poweroff' }) }
      it { is_expected.to allow_value({ assert.to_s => 'poweroff-force' }) }
      it { is_expected.to allow_value({ assert.to_s => 'poweroff-immediate' }) }
      it { is_expected.to allow_value({ assert.to_s => 'exit' }) }
      it { is_expected.to allow_value({ assert.to_s => 'exit-force' }) }
      it { is_expected.to allow_value({ assert.to_s => 'soft-reboot' }) }
      it { is_expected.to allow_value({ assert.to_s => 'soft-reboot-force' }) }
      it { is_expected.to allow_value({ assert.to_s => 'kexec' }) }
      it { is_expected.to allow_value({ assert.to_s => 'kexec-force' }) }
      it { is_expected.to allow_value({ assert.to_s => 'halt' }) }
      it { is_expected.to allow_value({ assert.to_s => 'halt-force' }) }
      it { is_expected.to allow_value({ assert.to_s => 'halt-immediate' }) }
      it { is_expected.not_to allow_value({ assert.to_s => '' }) }
      it { is_expected.not_to allow_value({ assert.to_s => 'another-action' }) }
    end
  end

  # ExitStatus
  %w[FailureActionExitStatus SuccessActionExitStatus].each do |assert|
    context "with a key of #{assert} can have appropriate values" do
      it { is_expected.to allow_value({ assert.to_s => '' }) }
      it { is_expected.to allow_value({ assert.to_s => 0 }) }
      it { is_expected.to allow_value({ assert.to_s => 128 }) }
      it { is_expected.to allow_value({ assert.to_s => 255 }) }
      it { is_expected.not_to allow_value({ assert.to_s => -1 }) }
      it { is_expected.not_to allow_value({ assert.to_s => 256 }) }
      it { is_expected.not_to allow_value({ assert.to_s => '1' }) }
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

  # Booleans
  %w[DefaultDependencies IgnoreOnIsolate StopWhenUnneeded RefuseManualStart RefuseManualStop AllowIsolate SurviveFinalKillSignal].each do |assert|
    context "with a key of #{assert} can have values set to true" do
      it { is_expected.to allow_value({ assert.to_s => true }) }
      it { is_expected.to allow_value({ assert.to_s => false }) }
      it { is_expected.not_to allow_value({ assert.to_s => 'yes' }) }
    end
  end

  it { is_expected.not_to allow_value({ 'Description' => 10 }) }
  it { is_expected.not_to allow_value({ 'Wants' => '/unitwith.service' }) }

  it { is_expected.not_to allow_value({ 'Wants' => 'noextension' }) }
  it { is_expected.not_to allow_value({ 'Wants' => ['noextension'] }) }
  it { is_expected.not_to allow_value({ 'ConditionPathExists' => 'not/an/absolute/path' }) }
  it { is_expected.not_to allow_value({ 'ConditionPathExists' => ['not/an/absolute/path'] }) }

  it { is_expected.to allow_value({ 'CollectMode' => 'inactive' }) }
  it { is_expected.to allow_value({ 'CollectMode' => 'inactive-or-failed' }) }
  it { is_expected.not_to allow_value({ 'CollectMode' => 'active' }) }

  it { is_expected.to allow_value({ 'RequiresMountsFor' => '/an/absolute/path' }) }
  it { is_expected.to allow_value({ 'RequiresMountsFor' => '' }) }
  it { is_expected.to allow_value({ 'RequiresMountsFor' => ['', '/an/absolute/path'] }) }
  it { is_expected.not_to allow_value({ 'RequiresMountsFor' => 'not/an/absolute/path' }) }
  it { is_expected.not_to allow_value({ 'RequiresMountsFor' => ['not/a/path'] }) }
  it { is_expected.not_to allow_value({ 'RequiresMountsFor' => [] }) }
end
