# frozen_string_literal: true

require_relative 'examples'
require_relative 'serverspec_extensions'

def configure_beaker(modules: :metadata, &block)
  collection = ENV['BEAKER_PUPPET_COLLECTION'] || 'puppet'
  ENV['BEAKER_DEBUG'] ||= 'true'
  ENV['BEAKER_HYPERVISOR'] ||= 'docker'

  # On Ruby 3 this doesn't appear to matter but on Ruby 2 beaker-hiera must be
  # included before beaker-rspec so Beaker::DSL is final
  require 'beaker-hiera'
  require 'beaker_puppet_helpers'
  require 'beaker-rspec'

  require_relative 'fixtures' if modules == :fixtures

  unless ENV['BEAKER_PROVISION'] == 'no'
    block_on hosts, run_in_parallel: true do |host|
      unless %w[none preinstalled].include?(collection)
        BeakerPuppetHelpers::InstallUtils.install_puppet_release_repo_on(host, collection)
      end
      beaker_package_name = BeakerPuppetHelpers::InstallUtils.package_name(host, prefer_aio: collection != 'none', requirement_name: collection.gsub(/\d+/, ''))
      package_name = ENV.fetch('BEAKER_PUPPET_PACKAGE_NAME', beaker_package_name)
      host.install_package(package_name)

      # by default, puppet-agent creates /etc/profile.d/puppet-agent.sh which adds /opt/puppetlabs/bin to PATH
      # in our non-interactive ssh sessions we manipulate PATH in ~/.ssh/environment, we need to do this step here as well
      host.add_env_var('PATH', '/opt/puppetlabs/bin')
    end
  end

  RSpec.configure do |c|
    # Readable test descriptions
    c.formatter = :documentation

    # Configure all nodes in nodeset
    c.before :suite do
      case modules
      when :metadata
        install_local_module_on(hosts)
      when :fixtures
        fixture_modules = File.join(Dir.pwd, 'spec', 'fixtures', 'modules')
        Voxpupuli::Acceptance::Fixtures.install_fixture_modules_on(hosts, fixture_modules)
      end

      if RSpec.configuration.suite_configure_facts_from_env
        require_relative 'facts'
        Voxpupuli::Acceptance::Facts.write_beaker_facts_on(hosts)
      end

      if RSpec.configuration.suite_hiera?
        hiera_data_dir = RSpec.configuration.suite_hiera_data_dir

        if Dir.exist?(hiera_data_dir)
          write_hiera_config_on(hosts, RSpec.configuration.suite_hiera_hierachy)
          copy_hiera_data_to(hosts, hiera_data_dir)
        end
      end

      local_setup = RSpec.configuration.setup_acceptance_node
      local_setup_content = File.exist?(local_setup) ? File.read(local_setup) : nil
      hosts.each do |host|
        yield host if block

        if local_setup_content
          puts "Configuring #{host} by applying #{local_setup}"
          apply_manifest_on(host, local_setup_content, catch_failures: true)
        end
      end
    end
  end
end

RSpec.configure do |c|
  c.formatter = 'RSpec::Github::Formatter' if ENV['GITHUB_ACTIONS'] == 'true'

  # Fact handling
  c.add_setting :suite_configure_facts_from_env, default: true

  # Hiera settings
  c.add_setting :suite_hiera, default: true
  c.add_setting :suite_hiera_data_dir, default: File.join('spec', 'acceptance', 'hieradata')
  c.add_setting :suite_hiera_hierachy, default: [
    {
      name: 'Per-node data',
      path: 'fqdn/%{facts.networking.fqdn}.yaml',
    },
    {
      name: 'OS family version data',
      path: 'family/%{facts.os.family}/%{facts.os.release.major}.yaml',
    },
    {
      name: 'OS family data',
      path: 'family/%{facts.os.family}.yaml',
    },
    {
      name: 'Common data',
      path: 'common.yaml',
    },
  ]

  # Node setup
  c.add_setting :setup_acceptance_node, default: File.join('spec', 'setup_acceptance_node.pp')
end
