# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Basic integration test' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) { 'include defaults_serverspec' }
  end

  describe curl_command('http://localhost') do
    its(:response_code) { is_expected.to eq(200) }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
