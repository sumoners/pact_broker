require 'pact_broker/repositories'

def create_pricing_service
  PactBroker::Models::Pacticipant.new(:name => 'Pricing Service', :repository_url => 'git@git.realestate.com.au:business-systems/condor.git').save(raise_on_save_failure: true).id
end

def create_condor
  PactBroker::Models::Pacticipant.new(:name => 'Condor').save(raise_on_save_failure: true).id
end

def create_version number, pacticipant_id
  PactBroker::Models::Version.new(number: number, pacticipant_id: pacticipant_id).save.id
end

def create_pact version_id, provider_id
  PactBroker::Models::Pact.new(version_id: version_id, provider_id: provider_id, json_content: '').save.id
end

Pact.provider_states_for "Pact Broker Client" do

  provider_state "the 'Pricing Service' does not exist in the pact-broker" do
    no_op
  end

  provider_state "the 'Pricing Service' already exists in the pact-broker" do
    set_up do
      create_pricing_service
    end
  end

  provider_state "an error occurs while publishing a pact" do
    set_up do
      PactBroker::Services::PactService.stub(:create_or_update_pact).and_raise("an error")
      # Your set up code goes here
    end
  end

  provider_state "a pact between Condor and the Pricing Service exists" do
    set_up do
      PactBroker::Repositories.pacticipant_repository.create(:name => 'Pricing Service', :repository_url => 'git@git.realestate.com.au:business-systems/condor.git')
    end
  end

  provider_state "no pact between Condor and the Pricing Service exists" do
    no_op
  end

  provider_state "the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0" do
    set_up do
      pricing_service_id = create_pricing_service
      condor_id = create_condor
      version_id = create_version '1.3.0', condor_id
      create_pact version_id, pricing_service_id
    end
  end

end
