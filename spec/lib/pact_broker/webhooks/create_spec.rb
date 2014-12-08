require 'spec_helper'
require 'pact_broker/webhooks/create'

module PactBroker

  module Pacts
    describe Create do

      let(:request_body) { load_fixture('webhook_valid.json') }

      subject { PactBroker::Pacts::Create.new }

      describe "validation_errors" do
        context "when validation passes" do
          it "returns empty validation errors" do
            expect(subject.validation_errors(request_body)).to be_empty
          end
        end

        context "when validation fails" do

          let(:request_body) { '{}' }

          it "returns validation errors" do
            expect(subject.validation_errors(request_body)).to_not be_empty
          end
        end
      end

      describe "process" do
        let(:webhook_service) { PactBroker::Services::WebhookService }
        let(:new_webhook) { double('new webhook') }
        let(:consumer) { double('consumer') }
        let(:provider) { double('provider') }
        let(:next_uuid) { '1234' }

        before do
          allow(webhook_service).to receive(:create).and_return(new_webhook)
        end

        it "creates the webhook" do
          expect(webhook_service).to receive(:create).with(next_uuid, instance_of(PactBroker::Domain::Webhook), consumer, provider)
          expect(subject.process(request_body, next_uuid, consumer, provider))
        end

        it "returns the webhook" do
          expect(subject.process(request_body, next_uuid, consumer, provider)).to be new_webhook
        end
      end

    end
  end
end
