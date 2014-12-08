require 'trailblazer/operation'
require 'pact_broker/services'
require 'pact_broker/api/contracts/put_pact_params_contract'

module PactBroker

  module Pacts
    class Create < Trailblazer::Operation

      include PactBroker::Services
      extend PactBroker::Services

      def process params
        pact_service.create_or_update_pact(params)
      end

      def validation_errors params, options = {}
        contract = PactBroker::Api::Contracts::PutPactParamsContract.new(params)
        unless contract.validate
          return contract.errors
        end
        potential_duplicate_pacticipants(params, options.fetch(:base_url))
      end

      # Need to fix this message - was made for text/plain, will now be in json
      def potential_duplicate_pacticipants params, base_url
        messages = pacticipant_service.messages_for_potential_duplicate_pacticipants params.pacticipant_names, base_url

        OpenStruct.new(
          :any? => messages.any?,
          :empty? => messages.empty?,
          :full_messages => messages)
      end

    end
  end
end
