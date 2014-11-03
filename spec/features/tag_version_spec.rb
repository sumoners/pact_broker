describe "Tagging a version" do

  let(:url) { '/pacticipants/Consumer/versions/1.2.3/tags' }
  let(:tag_hash) { { name: "production", value: "true" } }
  let(:rack_env) { { 'Content-Type' => 'application/json' } }
  let(:response_body) { JSON.parse(last_response.body, symbolize_names: true) }

  subject { post url, tag_hash, rack_env; last_response }

  context "when the version exists" do
    it "returns a 201 Created" do
      expect(subject.status).to eq 201
    end
    it "returns an application/hal+json Content-Type" do
      expect(subject.headers['Content-Type']).to eq 'application/hal+json'
    end
    it "returns the newly created tag in the response body" do
      expect(response_body).to include tag_hash
    end
    it "returns the Location of the new tag" do
      expect(subject.headers['Location']).to eq 'http://example.org' + url + '/production-0'
    end
  end

  context "when the version does not exist" do
    it "returns a 404" do
      expect(subject.status).to eq 404
    end
  end
end