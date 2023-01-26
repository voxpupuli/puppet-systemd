# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Service::Exec' do
  [
    '',
    '/usr/bin/doit.sh',
    'doit.sh',
    '/usr/bin/doit.sh and some arguments',
    'doit.sh and some arguments',
    '/usr/bin/doit.sh and some arguments/containing/a/slash',
    'doit.sh and some arguments/containing/a/slash',

    '@/usr/bin/doit.sh',
    '@doit.sh',
    '@/usr/bin/doit.sh and some arguments',
    '@doit.sh and some arguments',

    '-/usr/bin/doit.sh',
    '-doit.sh',
    '-/usr/bin/doit.sh and some arguments',
    '-doit.sh and some arguments',

    ':/usr/bin/doit.sh',
    ':doit.sh',
    ':/usr/bin/doit.sh and some arguments',
    ':doit.sh and some arguments',

    '+/usr/bin/doit.sh',
    '+doit.sh',
    '+/usr/bin/doit.sh and some arguments',
    '+doit.sh and some arguments',

    '!/usr/bin/doit.sh',
    '!doit.sh',
    '!/usr/bin/doit.sh and some arguments',
    '!doit.sh and some arguments',

    '!!/usr/bin/doit.sh',
    '!!doit.sh',
    '!!/usr/bin/doit.sh and some arguments',
    '!!doit.sh and some arguments',

    '@-:+/usr/bin/doit.sh',
    '@-:+doit.sh',
    '@-:+/usr/bin/doit.sh and some arguments',
    '@-:+doit.sh and some arguments',

    '@-:!/usr/bin/doit.sh',
    '@-:!doit.sh',
    '@-:!/usr/bin/doit.sh and some arguments',
    '@-:!doit.sh and some arguments',

    '@-:!!/usr/bin/doit.sh',
    '@-:!!doit.sh',
    '@-:!!/usr/bin/doit.sh and some arguments',
    '@-:!!doit.sh and some arguments',

    '-:+@/usr/bin/doit.sh',
    '-:+@doit.sh',
    '-:+@/usr/bin/doit.sh and some arguments',
    '-:+@doit.sh and some arguments',

    '-:!@/usr/bin/doit.sh',
    '-:!@doit.sh',
    '-:!@/usr/bin/doit.sh and some arguments',
    '-:!@doit.sh and some arguments',

    '-:!!@/usr/bin/doit.sh',
    '-:!!@doit.sh',
    '-:!!@/usr/bin/doit.sh and some arguments',
    '-:!!@doit.sh and some arguments',

  ].each do |exec|
    context "with a value of #{exec} is permitted" do
      it { is_expected.to allow_value(exec.to_s) }
    end
  end

  [
    'single/slash',
    '+!/bin/doit.sh',
    '+!!/bin/doit.sh',
    '!+/bin/doit.sh',
    '!!+/bin/doit.sh',
  ].each do |exec|
    context "with a value of #{exec} is not permitted" do
      it { is_expected.not_to allow_value(exec.to_s) }
    end
  end
end
