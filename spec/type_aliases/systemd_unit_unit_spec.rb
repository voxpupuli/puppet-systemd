# frozen_string_literal: true

require 'spec_helper'

# =============================================================================
# Shared value fixtures
#
# Each constant covers one Puppet type shape.  Keeping them here makes it
# immediately obvious what the contract is for every group below and means a
# single edit propagates everywhere that shape is used.
# =============================================================================

# Variant[String, Array[String,1]]
# Any string (including empty) or a non-empty array of strings.
FREE_STRING_VALID   = ['value', '', ['value'], ['', 'value'], %w[alpha beta]].freeze
FREE_STRING_INVALID = [[], 42].freeze

# Variant[Enum[''], Systemd::Unit, Array[Variant[Enum[''], Systemd::Unit], 1]]
# Empty-string reset, a valid unit name (has extension, no leading slash),
# or a non-empty array of those.
UNIT_VALID = [
  'foobar.service',
  ['foobar.service'],
  %w[alpha.service beta.service],
  '',
  [''],
  ['', 'foobar.service'],
].freeze
UNIT_INVALID = [
  '/unitwith.service', # leading slash not permitted
  'noextension',       # must have a unit-type suffix
  ['noextension'],
].freeze

# Variant[Enum[''], Stdlib::Unixpath, Array[Variant[Enum[''], Stdlib::Unixpath], 1]]
# Empty-string reset, an absolute path, or a non-empty array of those.
# No negation prefix; no empty array.
ABSPATH_VALID = [
  '/an/absolute/path',
  '',
  ['', '/an/absolute/path'],
].freeze
ABSPATH_INVALID = [
  'not/absolute',
  ['not/absolute'],
  [],
].freeze

# Variant[Enum[''], Stdlib::Unixpath, Pattern[/^!.*/], Array[...same..., 1]]
# Empty-string reset, absolute path, negated path (!...), or non-empty array.
NEGATABLE_PATH_VALID = [
  '/my/path',
  '!/my/path',
  '',
  ['', '/my/path', '!/my/other/path'],
].freeze
NEGATABLE_PATH_INVALID = [
  'not/absolute',
  ['not/absolute'],
  [],
].freeze

# Boolean - native Ruby true/false only; systemd strings like 'yes' rejected.
BOOL_VALID   = [true, false].freeze
BOOL_INVALID = ['yes', '', 1].freeze

# =============================================================================
# Key groups - grouped first by value type, then alphabetically within Assert*
# and Condition* sections.  All constants live at file scope to satisfy
# Lint/ConstantDefinitionInBlock and RSpec/LeakyConstantDeclaration.
# =============================================================================

FREE_STRING_TOP_KEYS = %w[Description Documentation].freeze

UNIT_DEPENDENCY_KEYS = %w[
  Wants
  Requires
  Requisite
  BindsTo
  PartOf
  Upholds
  Conflicts
  Before
  After
  OnFailure
  OnSuccess
  PropagatesReloadTo
  ReloadPropagatedFrom
  PropagatesStopTo
  StopPropagatedFrom
  JoinsNamespaceOf
].freeze

JOB_MODE_KEYS  = %w[OnSuccessJobMode OnFailureJobMode].freeze
JOB_MODE_VALID = %w[
  fail
  replace
  replace-irreversibly
  isolate
  flush
  ignore-dependencies
  ignore-requirements
].freeze
JOB_MODE_INVALID = ['', 'unknown-mode'].freeze

UNIT_BOOL_KEYS = %w[
  IgnoreOnIsolate
  StopWhenUnneeded
  RefuseManualStart
  RefuseManualStop
  AllowIsolate
  DefaultDependencies
  SurviveFinalKillSignal
].freeze

COLLECT_MODE_VALID   = %w[inactive inactive-or-failed].freeze
COLLECT_MODE_INVALID = ['active', ''].freeze

ACTION_KEYS  = %w[FailureAction SuccessAction].freeze
ACTION_VALID = %w[
  none
  reboot reboot-force reboot-immediate
  poweroff poweroff-force poweroff-immediate
  exit exit-force
  soft-reboot soft-reboot-force
  kexec kexec-force
  halt halt-force halt-immediate
].freeze
ACTION_INVALID = ['', 'unknown-action'].freeze

EXIT_STATUS_KEYS    = %w[FailureActionExitStatus SuccessActionExitStatus].freeze
EXIT_STATUS_VALID   = ['', 0, 128, 255].freeze
EXIT_STATUS_INVALID = [-1, 256, '1'].freeze

# Assert* ------------------------------------------------------------------ #

ASSERT_FREE_STRING_KEYS = %w[
  AssertArchitecture
  AssertFirmware
  AssertVirtualization
  AssertHost
  AssertKernelCommandLine
  AssertKernelVersion
  AssertVersion
  AssertCredential
  AssertEnvironment
  AssertSecurity
  AssertCapability
  AssertNeedsUpdate
  AssertKernelModuleLoaded
].freeze

ASSERT_BOOL_KEYS = %w[AssertACPower AssertFirstBoot].freeze

ASSERT_PATH_KEYS = %w[
  AssertPathExists
  AssertPathExistsGlob
  AssertPathIsDirectory
  AssertPathIsSymbolicLink
  AssertPathIsMountPoint
  AssertPathIsReadWrite
  AssertPathIsEncrypted
  AssertPathIsSocket
  AssertFileNotEmpty
  AssertDirectoryNotEmpty
  AssertFileIsExecutable
].freeze

# Condition* --------------------------------------------------------------- #

CONDITION_FREE_STRING_KEYS = %w[
  ConditionArchitecture
  ConditionFirmware
  ConditionVirtualization
  ConditionHost
  ConditionKernelCommandLine
  ConditionKernelVersion
  ConditionVersion
  ConditionCredential
  ConditionEnvironment
  ConditionSecurity
  ConditionCapability
  ConditionNeedsUpdate
  ConditionKernelModuleLoaded
].freeze

CONDITION_BOOL_KEYS = %w[ConditionACPower ConditionFirstBoot].freeze

CONDITION_PATH_KEYS = %w[
  ConditionPathExists
  ConditionPathExistsGlob
  ConditionPathIsDirectory
  ConditionPathIsSymbolicLink
  ConditionPathIsMountPoint
  ConditionPathIsReadWrite
  ConditionPathIsEncrypted
  ConditionPathIsSocket
  ConditionDirectoryNotEmpty
  ConditionFileNotEmpty
  ConditionFileIsExecutable
].freeze

# =============================================================================
# Spec
# =============================================================================

describe 'Systemd::Unit::Unit' do
  # ---------------------------------------------------------------------------
  # Description / Documentation
  # Variant[String, Array[String,1]]
  # ---------------------------------------------------------------------------

  FREE_STRING_TOP_KEYS.each do |key|
    context key do
      FREE_STRING_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      FREE_STRING_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
      # Reject non-string scalars (Integer, etc.)
      it { is_expected.not_to allow_value({ key => 10 }) }
    end
  end

  # ---------------------------------------------------------------------------
  # Unit dependencies
  # Variant[Enum[''], Systemd::Unit, Array[Variant[Enum[''], Systemd::Unit], 1]]
  # ---------------------------------------------------------------------------

  UNIT_DEPENDENCY_KEYS.each do |key|
    context key do
      UNIT_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      UNIT_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # RequiresMountsFor
  # Variant[Enum[''], Stdlib::Unixpath, Array[Variant[Enum[''], Stdlib::Unixpath], 1]]
  # Absolute paths only - no negation prefix.
  # ---------------------------------------------------------------------------

  context 'RequiresMountsFor' do
    ABSPATH_VALID.each   { |v| it { is_expected.to     allow_value({ 'RequiresMountsFor' => v }) } }
    ABSPATH_INVALID.each { |v| it { is_expected.not_to allow_value({ 'RequiresMountsFor' => v }) } }
  end

  # ---------------------------------------------------------------------------
  # JobMode
  # Enum[...] - no empty string, no unknown values
  # ---------------------------------------------------------------------------

  JOB_MODE_KEYS.each do |key|
    context key do
      JOB_MODE_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      JOB_MODE_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # Boolean unit-behaviour flags
  # Boolean only - no 'yes'/'no' strings
  # ---------------------------------------------------------------------------

  UNIT_BOOL_KEYS.each do |key|
    context key do
      BOOL_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      BOOL_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # CollectMode
  # Enum['inactive', 'inactive-or-failed']
  # ---------------------------------------------------------------------------

  context 'CollectMode' do
    COLLECT_MODE_VALID.each   { |v| it { is_expected.to     allow_value({ 'CollectMode' => v }) } }
    COLLECT_MODE_INVALID.each { |v| it { is_expected.not_to allow_value({ 'CollectMode' => v }) } }
  end

  # ---------------------------------------------------------------------------
  # Action
  # Enum[...] - no empty string, no unknown values
  # ---------------------------------------------------------------------------

  ACTION_KEYS.each do |key|
    context key do
      ACTION_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      ACTION_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # ExitStatus
  # Variant[Enum[''], Integer[0, 255]]
  # ---------------------------------------------------------------------------

  EXIT_STATUS_KEYS.each do |key|
    context key do
      EXIT_STATUS_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      EXIT_STATUS_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # StartLimit scalars
  # ---------------------------------------------------------------------------

  context 'StartLimitIntervalSec' do
    # String[1] - any non-empty string
    it { is_expected.to     allow_value({ 'StartLimitIntervalSec' => '12 hours' }) }
    it { is_expected.to     allow_value({ 'StartLimitIntervalSec' => 'infinity' }) }
    it { is_expected.not_to allow_value({ 'StartLimitIntervalSec' => '' }) }
  end

  context 'StartLimitBurst' do
    # Integer[1] - positive integers only
    it { is_expected.to     allow_value({ 'StartLimitBurst' => 1 }) }
    it { is_expected.to     allow_value({ 'StartLimitBurst' => 5 }) }
    it { is_expected.not_to allow_value({ 'StartLimitBurst' => 0 }) }
    it { is_expected.not_to allow_value({ 'StartLimitBurst' => '5' }) }
  end

  # ===========================================================================
  # Assert* keys
  # ===========================================================================

  # ---------------------------------------------------------------------------
  # Assert: free-string checks
  # Variant[String, Array[String,1]]
  # systemd accepts an optional leading '!' at runtime; we accept any string.
  # ---------------------------------------------------------------------------

  ASSERT_FREE_STRING_KEYS.each do |key|
    context key do
      FREE_STRING_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      FREE_STRING_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # Assert: boolean checks
  # Boolean only
  # ---------------------------------------------------------------------------

  ASSERT_BOOL_KEYS.each do |key|
    context key do
      BOOL_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      BOOL_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # Assert: path checks (absolute path or negated, empty-string reset allowed)
  # Variant[Enum[''], Stdlib::Unixpath, Pattern[/^!.*/], Array[...same..., 1]]
  # ---------------------------------------------------------------------------

  ASSERT_PATH_KEYS.each do |key|
    context key do
      NEGATABLE_PATH_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      NEGATABLE_PATH_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ===========================================================================
  # Condition* keys
  # ===========================================================================

  # ---------------------------------------------------------------------------
  # Condition: free-string checks
  # Variant[String, Array[String,1]]
  # ---------------------------------------------------------------------------

  CONDITION_FREE_STRING_KEYS.each do |key|
    context key do
      FREE_STRING_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      FREE_STRING_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # Condition: boolean checks
  # Boolean only
  # ---------------------------------------------------------------------------

  CONDITION_BOOL_KEYS.each do |key|
    context key do
      BOOL_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      BOOL_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # Condition: path checks (absolute path or negated, empty-string reset allowed)
  # Variant[Enum[''], Stdlib::Unixpath, Pattern[/^!.*/], Array[...same..., 1]]
  # ---------------------------------------------------------------------------

  CONDITION_PATH_KEYS.each do |key|
    context key do
      NEGATABLE_PATH_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      NEGATABLE_PATH_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end
end
