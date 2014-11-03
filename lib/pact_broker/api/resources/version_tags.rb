require 'pact_broker/api/resources/base_resource'

module PactBroker
  module Api
    module Resources

      class VersionTags < BaseResource

        def content_types_accepted
          [["application/json", :from_json]]
        end

        def allowed_methods
          ["POST"]
        end

        def post_is_create?
          true
        end

        def create_path
          base_url + "/" + next_id
        end

        def from_json
          @tag = tag_service.create identifier_from_path.merge(id: next_id), params
          response.body = to_json
        end

        def to_json
          PactBroker::Api::Decorators::TagDecorator.new(tag).to_json(base_url: base_url)
        end

        def next_id
          @next_id ||= tag_service.next_id identifier_from_path
        end

        private

        attr_accessor :tag

      end
    end

  end
end