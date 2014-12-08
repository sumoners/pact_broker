require 'cgi'
require 'pact_broker/api/resources/base_resource'
require 'pact_broker/api/resources/pacticipant_resource_methods'
require 'pact_broker/api/decorators/pact_decorator'
require 'pact_broker/json'
require 'pact_broker/pacts/pact_params'
require 'pact_broker/api/contracts/put_pact_params_contract'
require 'lib/pact_broker/pacts/create'
require 'lib/pact_broker/pacts/delete'
require 'lib/pact_broker/pacts/find'

module PactBroker

  module Api
    module Resources

      class Pact < BaseResource

        OPERATIONS = {
          'GET' => PactBroker::Pacts::Find,
          'PUT' => PactBroker::Pacts::Create,
          'DELETE' => PactBroker::Pacts::Delete
        }

        def initialize
          @operation = OPERATIONS[request.method].build(pact_params)
        end

        include PacticipantResourceMethods

        def content_types_provided
          [["application/json", :to_json]]
        end

        def content_types_accepted
          [["application/json", :from_json]]
        end

        def allowed_methods
          ["GET", "PUT", "DELETE"]
        end

        def malformed_request?
          return true if request.put? && invalid_json?
          errors = @operation.validation_errors(pact_params, base_url: base_url)
          set_json_validation_error_messages errors.full_messages if errors.any?
          errors.any?
        end

        def resource_exists?
          pact
        end

        def from_json
          response_code = pact ? 200 : 201
          result, @pact = @operation.process(pact_params)
          response.body = to_json
          response_code
        end

        def to_json
          PactBroker::Api::Decorators::PactDecorator.new(pact).to_json(base_url: base_url)
        end

        def delete_resource
          @operation.process(pact_params)
          true
        end

        private

        def pact
          @pact ||= PactBroker::Pacts::Find.run(pact_params).last
        end

        def pact_params
          @pact_params ||= PactBroker::Pacts::PactParams.from_request request, path_info
        end

      end
    end
  end
end