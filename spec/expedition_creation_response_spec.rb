require 'spec_helper'

describe TNTApi::ExpedtitionCreationResponse do
  let(:handler) { TNTApi::RequestHandler }
  let(:call) { handler.request(:expedition_creation, {}) }

  describe "#new" do

    before do
      configure_client
    end

    it "parses the response" do
      VCR.use_cassette('expedition_creation_with_valid_attributes') do
        response = TNTApi::ExpedtitionCreationResponse.new(call)
        expect(response.object.pdf_labels).to_not be_nil
        expect(response.object.parcel_number).to_not be_nil
        expect(response.object.tracking_url).to_not be_nil
      end
    end
  end
end
