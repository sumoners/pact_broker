require 'spec_helper'

require 'pact_broker/models'
require 'pact_broker/api/representors'

module PactBroker::Api::Representors

  describe PactCollectionRepresenter do

    let(:pact) do
      provider = PactBroker::Models::Pacticipant.new(:name => 'Pricing Service')
      provider.id = 1
      require 'pry'; pry(binding);
      consumer = PactBroker::Models::Pacticipant.new(:name => 'Condor')
      consumer.id = 2
      version = PactBroker::Models::Version.new(:number => '1.3.0', :pacticipant => consumer)
      version.id = 3
      pact = PactBroker::Models::Pact.new(:version => version, :provider => provider)
      pact.id = 4
      require 'pry'; pry(binding);
    end
    it "should description" do
      pact
    end
  end

end