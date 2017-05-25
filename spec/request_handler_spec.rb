require 'spec_helper'

describe TNTApi::RequestHandler do
  let(:handler) { TNTApi::RequestHandler }

  let(:attributes) {
    {
      first_name: "Helene",
      last_name: "POCHET",
      address_line1: "640 chemin de Saint Julien",
      address_line2: "",
      zip_code: "19290",
      city: "MILLEVACHES",
      email: "test@hotmail.fr",
      phone: "0602030405",
      access_code: "1234B",
      building_id: "1",
      floor_number: "5",
      instructions: "PORTE GAUCHE",
      notify_receiver: 0,
      service_code: "JZ",
      saturday_delivery: 0,
    }
  }

  let(:valid_attributes) { attributes.merge({ shipping_date: Date.tomorrow }) }
  let(:invalid_attributes) { attributes.merge({ shipping_date: "?" }) }

  before do
    configure_client
  end

  describe ".request" do
    context "when 'create_shipment' command is given" do
      context "with valid attributes" do
        it "returns successful response" do
          VCR.use_cassette('expedition_creation_with_valid_attributes') do
            response = handler.request(:expedition_creation, valid_attributes)
            expect(response.pdf_labels).to_not be_nil
            expect(response.parcel_number).to_not be_nil
            expect(response.tracking_url).to_not be_nil
          end
        end
      end
      context "with invalid attributes" do
        it "raise SOAP error" do
          VCR.use_cassette('expedition_creation_with_invalid_attributes') do
            expect {
              handler.request(:expedition_creation, invalid_attributes)
            }.to raise_error(TNTApi::SoapError)
          end
        end
      end
    end
  end
end
