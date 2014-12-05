require 'trailblazer/operation'
require 'pact_broker/services'

module PactBroker

  module Pacts
    class Find < Trailblazer::Operation

      include PactBroker::Services

      def process(params)
        model
      end

      def self.validation_errors *args
        []
      end

      private

      def model!
        pact_service.find_pact(params)
      end
    end

  end
end
