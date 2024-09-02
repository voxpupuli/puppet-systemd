# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::tmpfile' do
  _, facts = on_supported_os.first
  let(:facts) { facts }
  let(:title) { 'random_tmpfile.conf' }
  let(:params) { { content: 'random stuff' } }

  it { is_expected.to compile.with_all_deps }

  it {
    expect(subject).to create_file("/etc/tmpfiles.d/#{title}").with(
      ensure: 'file',
      content: %r{#{params[:content]}},
      mode: '0444'
    )
  }

  context 'with a bad tmpfile name' do
    let(:title) { 'test.badtype' }

    it {
      expect do
        expect(subject).to compile.with_all_deps
      end.to raise_error(%r{expects a match for Systemd::Dropin})
    }
  end

  context 'with a bad tmpfile name with slash' do
    let(:title) { 'test/foo.conf' }

    it {
      expect do
        expect(subject).to compile.with_all_deps
      end.to raise_error(%r{expects a match for Systemd::Dropin})
    }
  end

  context 'with a tmpfile name specified with filename' do
    let(:title) { 'test.badtype' }
    let(:params) do
      {
        filename: 'goodname.conf',
        content: 'random stuff',
      }
    end

    it {
      expect(subject).to create_file('/etc/tmpfiles.d/goodname.conf').with(
        ensure: 'file',
        content: %r{#{params[:content]}},
        mode: '0444'
      )
    }
  end
end
