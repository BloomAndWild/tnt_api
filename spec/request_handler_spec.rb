require 'spec_helper'

describe TntApi::RequestHandler do
  let(:handler) { TntApi::RequestHandler }

  before do
    configure_client
  end

  describe ".request" do
      context "when 'create_shipment' command is given" do
        it "returns tracking number" do
          VCR.use_cassette('create_shipment') do
            response = handler.request(:expeditionCreation, {})
            expect(response).to eq(nil)
          end
        end
      end
    end
end
