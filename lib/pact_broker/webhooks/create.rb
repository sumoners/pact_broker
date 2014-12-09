require 'trailblazer/operation'
require 'pact_broker/services'
require 'pact_broker/api/contracts/webhook_contract'
require 'pact_broker/domain/webhook'
require 'pact_broker/domain/webhook_request'
require 'pact_broker/api/contracts/request_validations'
require 'reform/form/json'

module PactBroker

  module Pacts
    class Create < Trailblazer::Operation

      include PactBroker::Services
      extend PactBroker::Services

      contract do
        include Reform::Form::JSON

        property :request
        validates :request, presence: true

        property :request do

          include PactBroker::Api::Contracts::RequestValidations

          property :url
          property :http_method

          validates :url, presence: true
          validates :http_method, presence: true

          validate :method_is_valid
          validate :url_is_valid

        end
      end

      contract_class = PactBroker::Api::Contracts::WebhookContract

      def process params, next_uuid, consumer, provider
        webhook = model
        validate(params, webhook) do | contract |
          contract.sync
          webhook = webhook_service.create next_uuid, webhook, consumer, provider
        end
        webhook
      end

      def validation_errors params
        contract = self.class.contract_class.new(model)
        contract.validate(params)
        contract.errors
      end

      private

      def model
        @model ||= PactBroker::Domain::Webhook.new(request: PactBroker::Domain::WebhookRequest.new)
      end

    end
  end
end
