require_relative 'base_api'

module PactBroker

  module Api

    class PactApi < BaseApi

      namespace '/pacticipant/:consumer/versions/:number/pacts' do
        put '/:provider' do
          pact, created = pact_service.create_or_update_pact(
            provider: params[:provider],
            consumer: params[:consumer],
            number: params[:number],
            json_content: request.body.read)
          created ? status(201) : status(200)
        end
      end
    end
  end
end
