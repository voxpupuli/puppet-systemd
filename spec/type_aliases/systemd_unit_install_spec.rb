# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Install' do
  %w[Alias WantedBy RequiredBy Also].each do |depend|
    context "with a key of #{depend} can have values of units" do
      it { is_expected.to allow_value({ depend.to_s => 'foobar.service' }) }
      it { is_expected.to allow_value({ depend.to_s => ['foobar.service'] }) }
      it { is_expected.to allow_value({ depend.to_s => ['alpha.service', 'beta.service'] }) }
      it { is_expected.to allow_value({ depend.to_s => '' }) }
      it { is_expected.to allow_value({ depend.to_s => [''] }) }
      it { is_expected.to allow_value({ depend.to_s => ['', 'foobar.service'] }) }
    end
  end

  it { is_expected.not_to allow_value({ 'Also' => 'noextension' }) }
  it { is_expected.not_to allow_value({ 'Also' => ['noextension'] }) }
end
