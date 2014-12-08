require 'trailblazer/operation'
require 'pact_broker/services'

module PactBroker

  module Pacts
    class Find < Trailblazer::Operation

      include PactBroker::Services

      def process(params)
        pact_service.find_pact(params)
      end

      def validation_errors *args
        []
      end

    end

  end
end
