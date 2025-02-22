# frozen_string_literal: true

# written by https://github.com/ekohl
# https://github.com/mizzy/serverspec/pull/611 was rejected so adding it here.

require 'serverspec'

module Voxpupuli
  module Acceptance
    module ServerspecExtensions
      class CurlCommand < Serverspec::Type::Command
        def response_code
          m = /Response-Code: (?<code>\d+)/.match(stderr)
          return 0 unless m

          m[:code].to_i
        end

        def body
          command_result.stdout
        end

        def body_as_json
          MultiJson.load(body)
        end

        private

        def curl_command
          # curl supports %{stderr} to --write-out since 7.63.0
          # so the following doesn't work on EL8, which has curl 7.61.1
          command = "curl --silent --write-out '%{stderr}Response-Code: %{response_code}\\n' '#{@name}'" # rubocop:disable Style/FormatStringToken

          @options.each do |option, value|
            case option
            when :cacert, :cert, :key
              command += " --#{option} '#{value}'"
            when :headers
              value.each do |header, header_value|
                command += if header_value
                             " --header '#{header}: #{header_value}'"
                           else
                             " --header '#{header};'"
                           end
              end
            else
              raise "Unknown option #{option} (value: #{value})"
            end
          end

          command
        end

        def command_result
          @command_result ||= @runner.run_command(curl_command)
        end
      end
    end
  end
end
