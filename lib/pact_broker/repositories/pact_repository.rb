require 'sequel'
require 'pact_broker/models/pacticipant'

module PactBroker
  module Repositories
    class PactRepository

      def find_by_version_and_provider version_id, provider_id
        PactBroker::Models::Pact.where(version_id: version_id, provider_id: provider_id).single_record
      end

      def create params
        PactBroker::Models::Pact.new(version_id: params[:version_id], provider_id: params[:provider_id], json_content: params[:json_content]).save
      end

      def create_or_update params
        if pact = find_by_version_and_provider(params[:version_id], params[:provider_id])
          pact.update_fields(json_content: params[:json_content])
        else
          create params
        end
      end

    end
  end
end