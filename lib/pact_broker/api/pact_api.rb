require 'pact_broker/logging'
require 'pact_broker/repositories'
require 'sequel'
require 'pact_broker/db'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'sinatra/param'
require 'pact_broker/models'

module PactBroker

  module Services
    module PactService

      extend self

      extend PactBroker::Repositories

      def create_or_update_pact params
        provider = pacticipant_repository.find_by_name params[:provider]
        consumer = pacticipant_repository.find_by_name_or_create params[:consumer]
        version = version_repository.find_by_pacticipant_id_and_number_or_create consumer.id, params[:number]

        if pact = pact_repository.find_by_version_and_provider(version.id, provider.id)
          http_status = 200
          pact.update(json_content: params[:json_content])
        else
          http_status = 201
          pact_repository.create json_content: params[:json_content], version_id: version.id, provider_id: provider.id
        end
        http_status
      end

    end
  end


  module Api

    class PactApi < Sinatra::Base

      helpers do
        include PactBroker::Logging
      end

      set :raise_errors, false
      set :show_exceptions, false


      error do
        e = env['sinatra.error']
        logger.error e
        content_type :json
        status 500
        {:message => e.message, :backtrace => e.backtrace }.to_json
      end

      helpers Sinatra::JSON
      helpers Sinatra::Param
      register Sinatra::Namespace

      namespace '/pacticipant/:consumer/versions/:number/pacts' do
        put '/:provider' do
          http_status = PactBroker::Services::PactService.create_or_update_pact(
            provider: params[:provider],
            consumer: params[:consumer],
            number: params[:number],
            json_content: request.body.read)
          status http_status
        end
      end
    end
  end
end
