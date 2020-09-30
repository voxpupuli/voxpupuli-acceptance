ENV_VAR_PREFIX = 'BEAKER_FACTER_'
FACT_FILE = '/etc/facter/facts.d/voxpupuli-acceptance-env.json'

def beaker_facts_from_env
  facts = {}

  ENV.each do |var, value|
    next unless var.start_with?(ENV_VAR_PREFIX)

    fact = var.sub(ENV_VAR_PREFIX, '').downcase
    facts[fact] = value
  end

  facts
end

def write_beaker_facts_on(hosts)
  beaker_facts = beaker_facts_from_env

  if beaker_facts.any?
    require 'json'
    on(hosts, "mkdir -p #{File.dirname(FACT_FILE)} && cat <<VOXPUPULI_BEAKER_ENV_VARS > #{FACT_FILE}\n#{beaker_facts.to_json}\nVOXPUPULI_BEAKER_ENV_VARS")
  else
    on(hosts, "rm -f #{FACT_FILE}")
  end
end

def configure_beaker(modules: :metadata, configure_facts_from_env: true, &block)
  ENV['PUPPET_INSTALL_TYPE'] ||= 'agent'
  ENV['BEAKER_PUPPET_COLLECTION'] ||= 'puppet6'
  ENV['BEAKER_debug'] ||= 'true'
  ENV['BEAKER_HYPERVISOR'] ||= 'docker'

  require 'beaker-rspec'
  require 'beaker-puppet'
  require 'beaker/puppet_install_helper'

  case modules
  when :metadata
    require 'beaker/module_install_helper'
    $module_source_dir = get_module_source_directory caller
  when :fixtures
    require_relative 'fixtures'
  end

  run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

  RSpec.configure do |c|
    # Readable test descriptions
    c.formatter = :documentation

    # Configure all nodes in nodeset
    c.before :suite do
      case modules
      when :metadata
        install_module
        install_module_dependencies
      when :fixtures
        fixture_modules = File.join(Dir.pwd, 'spec', 'fixtures', 'modules')
        Voxpupupli::Acceptance::Fixtures.install_fixture_modules_on(hosts, fixture_modules)
      end

      write_beaker_facts_on(hosts) if configure_facts_from_env

      if block
        hosts.each do |host|
          yield host
        end
      end
    end
  end
end
