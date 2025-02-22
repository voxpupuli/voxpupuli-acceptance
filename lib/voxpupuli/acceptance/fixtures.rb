require 'tmpdir'
require 'puppet/modulebuilder'

module Voxpupuli
  module Acceptance
    class Fixtures
      class << self
        # Install fixture modules on the given hosts
        #
        # @param [Host, Array<Host>, String, Symbol] hosts
        #   The beaker hosts to run on
        # @param [Array<String>, String] modulepath
        #   A modulepath as Puppet uses it. Typically spec/fixtures/modules
        # @param [Logger, nil] logger
        #   An optional logger
        def install_fixture_modules_on(hosts, modulepath, logger = nil)
          Dir.mktmpdir do |destination|
            modules = build_modules(modulepath, destination, logger)

            install_modules_on(hosts, modules, logger)
          end

          nil
        end

        # Build modules in the given sources.
        #
        # @param [Array<String>, String] modulepath
        #   A modulepath as Puppet uses it
        # @param [String] destination
        #   The target directory to build modules into
        # @param [Logger, nil] logger
        #   An optional logger
        #
        # @return [Hash<String=>String>]
        #   A mapping of module names and the path to their tarball
        def build_modules(modulepath, destination, logger = nil)
          modulepath = [modulepath] if modulepath.is_a?(String)

          modules = {}

          modulepath.each do |dir|
            Dir[File.join(dir, '*', 'metadata.json')].each do |metadata|
              path = File.dirname(metadata)
              name = File.basename(path)
              next if modules.include?(name)

              builder = Puppet::Modulebuilder::Builder.new(File.realpath(path), destination, logger)

              unless valid_directory_name?(name, builder.metadata['name'])
                warning = "Directory name of #{path} doesn't match metadata name #{builder.metadata['name']}"
                if logger
                  logger.warn(warning)
                else
                  warn(warning)
                end
              end

              modules[name] = builder.build
            end
          end

          modules
        end

        # Install modules on a number of hosts
        #
        # This is done by iterating over every host. On that host a temporary
        # directory is created. Each module is copied there and installed by
        # force.
        #
        # @param [Host, Array<Host>, String, Symbol] hosts
        #   The beaker hosts to run on
        # @param [Hash<String=>String>] modules
        #   A mapping between module names and their tarball
        # @param [Logger, nil] logger
        #   An optional logger
        def install_modules_on(hosts, modules, logger = nil)
          hosts.each do |host|
            logger.debug("Installing modules on #{host}") if logger

            temp_dir_on(host) do |target_dir|
              modules.each do |name, source_path|
                target_file = File.join(target_dir, File.basename(source_path))
                logger.debug("Copying module #{name} from #{source_path} to #{target_file}") if logger

                scp_to(host, source_path, target_file)
                on host, "puppet module install --force --ignore-dependencies '#{target_file}'"
              end
            end
          end

          nil
        end

        # Create a temporary directory on the host, similar to Dir.mktmpdir but
        # on a remote host.
        #
        # @example
        #   temp_dir_on(host) { |dir| puts dir }
        #
        # @param [Host, String, Symbol] host
        #   The beaker host to run on
        def temp_dir_on(host)
          result = on host, 'mktemp -d'
          raise 'Could not create directory' unless result.success?

          dir = result.stdout.strip

          begin
            yield dir
          ensure
            on host, "rm -rf #{dir}"
          end

          nil
        end

        # Validate a directory name matches its metadata name.
        #
        # This is useful to detect misconfigurations in fixture set ups.
        #
        # @example
        #   assert valid_directory_name?('tftp', 'theforeman-tftp')
        # @example
        #   refute valid_directory_name?('puppet-tftp', 'theforeman-tftp')
        #
        # @param [String] directory_name
        #   Name of the directory. Not the full path
        # @param [String] metadata_name
        #   Name as it shows up in the metadata. It is normalized and accepts
        #   both / and - as separators.
        #
        # @return [Boolean] Wether the directory name is valid with the given
        #   metadata name
        def valid_directory_name?(directory_name, metadata_name)
          normalized = metadata_name.tr('/', '-').split('-').last
          normalized == directory_name
        end
      end
    end
  end
end
