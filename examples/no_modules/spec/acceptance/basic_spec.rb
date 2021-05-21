require 'spec_helper_acceptance'

describe 'Basic integration test' do
  # Uses https://serverspec.org/resource_types.html#command
  describe command('echo Hello World') do
    its(:stdout) { is_expected.to eq("Hello World\n") }
    its(:exit_status) { is_expected.to eq(0) }
  end
end
