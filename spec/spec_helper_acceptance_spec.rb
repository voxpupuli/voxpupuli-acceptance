# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

describe 'spec_helper_acceptance' do
  describe '#configure_beaker' do
    context 'without provisioning' do
      before { ENV['BEAKER_PROVISION'] = 'no' }

      it 'configures RSpec' do
        allow(RSpec).to receive(:configure)
        configure_beaker
        expect(RSpec).to have_received(:configure).at_least(:once)
      end
    end
  end

  describe '#disable_dnssec_validation_on' do
    it 'skips hosts that are not Debian or Ubuntu' do
      host = { 'platform' => 'windows-2022-64' }

      allow(self).to receive(:on)
      disable_dnssec_validation_on(host)
      expect(self).not_to have_received(:on)
    end

    it 'runs the DNSSEC check on Debian and Ubuntu hosts' do
      host = { 'platform' => 'ubuntu-22.04-amd64' }

      allow(self).to receive(:on)
      disable_dnssec_validation_on(host)
      expect(self).to have_received(:on).with(host, DNSSEC_VALIDATION_FIX)
    end
  end
end
