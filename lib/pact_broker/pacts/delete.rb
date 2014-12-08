require 'trailblazer/operation'
require 'pact_broker/services'


module PactBroker

  module Pacts
    class Delete < Trailblazer::Operation

      include PactBroker::Services

      def process( ignored )
        pact_service.delete(params.first )
      end

      def validation_errors *args
        []
      end

    end
  end
end
