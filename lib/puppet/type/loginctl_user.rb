# frozen_string_literal: true

require 'digest/md5'

Puppet::Type.newtype(:loginctl_user) do
  newparam(:name, namevar: true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newproperty(:linger) do
    desc 'Whether linger is enabled for the user.'

    newvalues :enabled, :disabled
    defaultto :disabled
  end
end
