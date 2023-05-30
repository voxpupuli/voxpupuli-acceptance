require 'voxpupuli/acceptance/spec_helper_acceptance'

describe 'spec_helper_acceptance' do
  describe '#configure_beaker' do
    context 'without provisioning' do
      before(:example) { ENV['BEAKER_PROVISION'] = 'no' }

      it 'configures RSpec' do
        allow(RSpec).to receive(:configure)
        configure_beaker
        expect(RSpec).to have_received(:configure).at_least(:once)
      end
    end
  end
end
