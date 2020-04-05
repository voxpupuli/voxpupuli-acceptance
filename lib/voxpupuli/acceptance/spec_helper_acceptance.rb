def configure_beaker(&block)
  ENV['PUPPET_INSTALL_TYPE'] ||= 'agent'
  ENV['BEAKER_PUPPET_COLLECTION'] ||= 'puppet6'
  ENV['BEAKER_debug'] ||= 'true'
  ENV['BEAKER_HYPERVISOR'] ||= 'docker'

  require 'beaker-rspec'
  require 'beaker-puppet'
  require 'beaker/puppet_install_helper'
  require 'beaker/module_install_helper'
  $module_source_dir = get_module_source_directory caller

  run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

  RSpec.configure do |c|
    # Readable test descriptions
    c.formatter = :documentation

    # Configure all nodes in nodeset
    c.before :suite do
      install_module
      install_module_dependencies

      if block
        hosts.each do |host|
          yield host
        end
      end
    end
  end
end
