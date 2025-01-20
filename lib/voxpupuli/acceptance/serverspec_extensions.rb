require 'serverspec'
require_relative 'serverspec_extensions/curl_command'

module Serverspec
  module Helper
    module Type
      def curl_command(*args)
        Voxpupuli::Acceptance::ServerspecExtensions::CurlCommand.new(*args)
      end
    end
  end
end
