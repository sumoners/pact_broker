require 'trailblazer/operation'
require 'pact_broker/services'
require 'pact_broker/api/contracts/put_pact_params_contract'

module PactBroker

  module Pacts
    class Create < Trailblazer::Operation

      include PactBroker::Services
      extend PactBroker::Services

      def process(params)
        @model = pact_service.create_or_update_pact(params)
      end

      def self.validation_errors pact_params, base_url
        contract = PactBroker::Api::Contracts::PutPactParamsContract.new(pact_params)
        unless contract.validate
          return contract.errors
        end
        potential_duplicate_pacticipants(pact_params, base_url)
      end

      # Need to fix this message - was made for text/plain, will now be in json
      def self.potential_duplicate_pacticipants pact_params, base_url
        messages = pacticipant_service.messages_for_potential_duplicate_pacticipants pact_params.pacticipant_names, base_url

        OpenStruct.new(
          :any? => messages.any?,
          :empty? => messages.empty?,
          :full_messages => messages)
      end

    end
  end
end
