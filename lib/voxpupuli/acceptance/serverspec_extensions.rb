# frozen_string_literal: true

require 'serverspec'
require_relative 'serverspec_extensions/curl_command'

module Serverspec
  module Helper
    module Type
      def curl_command(*)
        Voxpupuli::Acceptance::ServerspecExtensions::CurlCommand.new(*)
      end
    end
  end
end
