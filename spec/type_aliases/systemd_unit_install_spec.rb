# frozen_string_literal: true

require 'spec_helper'

# =============================================================================
# Shared value fixtures
# =============================================================================

# Variant[Enum[''], Systemd::Unit, Array[Variant[Enum[''], Systemd::Unit], 1]]
# Empty-string reset, a valid unit name, or a non-empty array of those.
INSTALL_UNIT_VALID = [
  'foobar.service',
  ['foobar.service'],
  %w[alpha.service beta.service],
  '',
  [''],
  ['', 'foobar.service'],
].freeze
INSTALL_UNIT_INVALID = [
  'noextension',      # must have a unit-type suffix
  ['noextension'],
  '/foo.service',     # leading slash not permitted
  [],                 # empty array not permitted
].freeze

# Keys that take a unit name (or list of unit names).
INSTALL_UNIT_KEYS = %w[Alias WantedBy RequiredBy UpheldBy Also].freeze

describe 'Systemd::Unit::Install' do
  # ---------------------------------------------------------------------------
  # Unit-name keys
  # Variant[Enum[''], Systemd::Unit, Array[Variant[Enum[''], Systemd::Unit], 1]]
  # ---------------------------------------------------------------------------

  INSTALL_UNIT_KEYS.each do |key|
    context key do
      INSTALL_UNIT_VALID.each   { |v| it { is_expected.to     allow_value({ key => v }) } }
      INSTALL_UNIT_INVALID.each { |v| it { is_expected.not_to allow_value({ key => v }) } }
    end
  end

  # ---------------------------------------------------------------------------
  # DefaultInstance
  # String[1] - non-empty string usable as a template instance identifier.
  # ---------------------------------------------------------------------------

  context 'DefaultInstance' do
    it { is_expected.to     allow_value({ 'DefaultInstance' => '1' }) }
    it { is_expected.to     allow_value({ 'DefaultInstance' => 'primary' }) }
    it { is_expected.to     allow_value({ 'DefaultInstance' => 'eth0' }) }
    it { is_expected.not_to allow_value({ 'DefaultInstance' => '' }) }
    it { is_expected.not_to allow_value({ 'DefaultInstance' => 42 }) }
    it { is_expected.not_to allow_value({ 'DefaultInstance' => [] }) }
  end
end
