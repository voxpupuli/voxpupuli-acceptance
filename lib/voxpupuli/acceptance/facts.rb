# frozen_string_literal: true

module Voxpupuli
  module Acceptance
    class Facts
      ENV_VAR_PREFIX = 'BEAKER_FACTER_'
      FACT_FILE = '/etc/facter/facts.d/voxpupuli-acceptance-env.json'

      class << self
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
            on(hosts,
               "mkdir -p #{File.dirname(FACT_FILE)} && cat <<VOXPUPULI_BEAKER_ENV_VARS > #{FACT_FILE}\n#{beaker_facts.to_json}\nVOXPUPULI_BEAKER_ENV_VARS")
          else
            on(hosts, "rm -f #{FACT_FILE}")
          end
        end
      end
    end
  end
end
