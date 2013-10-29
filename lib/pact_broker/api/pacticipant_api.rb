require_relative 'base_api'
require 'pact_broker/services/pacticipant_service'

module PactBroker

  module Api


    class PacticipantApi < BaseApi

      namespace '/pacticipant' do
        get '/:name/repository_url' do
          logger.info "GET REPOSTORY URL #{params}"
          pacticipant = pacticipant_repository.find_by_name(params[:name])
          logger.info "Found pacticipant #{pacticipant}"
          if pacticipant && pacticipant.repository_url
            content_type 'text/plain'
            pacticipant.repository_url
          else
            status 404
          end
        end

        patch '/:name' do
          logger.info "Recieved request to patch #{params[:name]} with #{params}"
          pacticipant, created = PactBroker::Services::PacticipantService.create_or_update_pacticipant(
            name: params[:name],
            repository_url: params[:repository_url]
          )
          created ? status(201) : status(200)
          json pacticipant
        end
      end

    end
  end
end
