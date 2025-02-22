# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Basic integration test' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) { 'include defaults_fixtures' }
  end

  describe file('/voxpupuli-acceptance-test') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to eq("Current test: defaults_fixtures\n") }
  end
end
