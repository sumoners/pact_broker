require 'trailblazer/operation'
require 'pact_broker/services'
require 'pact_broker/api/contracts/put_pact_params_contract'

module PactBroker

  module Pacts
    class Create < Trailblazer::Operation

      include PactBroker::Services
      extend PactBroker::Services

      def process ignored
        @model = pact_service.create_or_update_pact(params.first)
      end

      def validation_errors options = {}
        contract = PactBroker::Api::Contracts::PutPactParamsContract.new(params.first)
        unless contract.validate
          return contract.errors
        end
        potential_duplicate_pacticipants(options.fetch(:base_url))
      end

      # Need to fix this message - was made for text/plain, will now be in json
      def potential_duplicate_pacticipants base_url
        messages = pacticipant_service.messages_for_potential_duplicate_pacticipants params.first.pacticipant_names, base_url

        OpenStruct.new(
          :any? => messages.any?,
          :empty? => messages.empty?,
          :full_messages => messages)
      end

    end
  end
end
