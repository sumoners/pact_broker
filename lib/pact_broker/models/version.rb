require 'sequel'

module PactBroker

  module Models

    class Version < Sequel::Model

      set_primary_key :id
      one_to_many :pacts
      associate(:one_to_one, :pacticipant, :class => "PactBroker::Models::Pacticipant", :key => :id, :primary_key => :pacticipant_id)

      def to_s
        "Version: number=#{number}, pacticipant=#{pacticipant_id}"
      end
    end
  end
end