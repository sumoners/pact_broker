describe "Getting a pact" do

  let(:pact_content) { load_fixture('consumer-provider.json') }
  let(:path) { "/pacts/provider/A%20Provider/consumer/A%20Consumer/version/1.2.3" }
  let(:response_body_json) { JSON.parse(subject.body) }

  subject { get path; last_response  }

  context "when the pact exists" do
    before do
      ProviderStateBuilder.new.create_pact_with_hierarchy "A Consumer", "1.2.3", "A Provider", pact_content
    end

    it "returns the pact" do
      expect(response_body_json).to include JSON.parse(pact_content)
    end

    it "returns a 200" do
      expect(subject.status).to be 200
    end
  end

  context "when the pact does not exist" do
    it "returns a 404 Not Found" do
      expect(subject.status).to be 404
    end
  end
end
