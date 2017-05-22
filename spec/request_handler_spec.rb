require 'spec_helper'

describe TntApi::RequestHandler do
  let(:handler) { TntApi::RequestHandler }

  before do
    configure_client
  end

  describe ".request" do
      context "when 'create_shipment' command is given" do
        it "returns tracking number" do
          VCR.use_cassette('expedition_creation') do
            response = handler.request(:expedition_creation, {})
            parcel_number = response.body[:expedition_creation_response][:expedition][:parcel_responses][:parcel_number]
            expect(parcel_number).not_to be_nil
          end
        end
      end
    end
end
