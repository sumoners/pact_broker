require 'trailblazer/operation'
require 'pact_broker/services'


module PactBroker

  module Pacts
    class Delete < Trailblazer::Operation

      include PactBroker::Services

      def process(params)
        pact_service.delete(params)
      end

      def self.validation_errors *args
        []
      end
    end
  end
end
