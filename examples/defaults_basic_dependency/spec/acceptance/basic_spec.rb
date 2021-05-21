require 'spec_helper_acceptance'

describe 'Basic integration test', order: :defined do
  describe 'an idempotent resource shared helper' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) { 'include defaults_basic_dependency' }
    end

    describe file('/voxpupuli-acceptance-test') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to eq('{"current_test":"defaults_basic_dependency"}') }
    end
  end

  describe 'the example shared example' do
    it_behaves_like 'the example', 'an_example.pp'

    describe file('/voxpupuli-acceptance-test') do
      it { is_expected.not_to be_file }
    end
  end
end
