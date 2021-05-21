require_relative 'examples'

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

  # On Ruby 3 this doesn't appear to matter but on Ruby 2 beaker-hiera must be
  # included before beaker-rspec so Beaker::DSL is final
  require 'beaker-hiera'
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
        Voxpupuli::Acceptance::Fixtures.install_fixture_modules_on(hosts, fixture_modules)
      end

      write_beaker_facts_on(hosts) if configure_facts_from_env

      if RSpec.configuration.suite_hiera?
        hiera_data_dir = RSpec.configuration.suite_hiera_data_dir

        if Dir.exist?(hiera_data_dir)
          write_hiera_config_on(hosts, RSpec.configuration.suite_hiera_hierachy)
          copy_hiera_data_to(hosts, hiera_data_dir)
        end
      end

      hosts.each do |host|
        if block
          yield host

          local_setup = RSpec.configuration.setup_acceptance_node
          if local_setup && File.exist?(local_setup)
            puts "Configuring #{host} by applying #{local_setup}"
            apply_manifest_on(host, File.read(local_setup), catch_failures: true)
          end
        end
      end
    end
  end
end

RSpec.configure do |c|
  # Hiera settings
  c.add_setting :suite_hiera, default: true
  c.add_setting :suite_hiera_data_dir, default: File.join('spec', 'acceptance', 'hieradata')
  c.add_setting :suite_hiera_hierachy, default: [
    'fqdn/%{fqdn}.yaml',
    'os/%{os.family}/%{os.release.major}.yaml',
    'os/%{os.family}.yaml',
    'common.yaml',
  ]

  # Node setup
  c.add_setting :setup_acceptance_node, default: File.join('spec', 'setup_acceptance_node.pp')
end
