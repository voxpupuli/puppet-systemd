# frozen_string_literal: true

require 'spec_helper'
require 'type_aliases/shared_systemd_resource_control'

describe 'Systemd::Unit::Slice' do
  # systemd.resource-control
  it_behaves_like 'systemd_resource_control'
end
