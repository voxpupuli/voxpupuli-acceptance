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
    it 'runs the DNSSEC repair command' do
      host = { 'platform' => 'ubuntu-22.04-amd64' }

      allow(self).to receive(:on)
      disable_dnssec_validation_on(host)
      expect(self).to have_received(:on).with(host, DNSSEC_VALIDATION_FIX)
    end
  end
end
