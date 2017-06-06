require 'spec_helper'

describe TNTApi::RequestHandler do
  let(:handler) { TNTApi::RequestHandler }

  let(:sender_attributes) do
    {
      sender_name: "TNT EXPRESS FRANCE",
      sender_address_line1: "58 AVENUE LECLERC",
      sender_address_line2: "",
      sender_zip_code: "44119",
      sender_city: "TREILLIERES",
      sender_contact_first_name: "HENRY",
      sender_contact_last_name: "DUPONT",
      sender_email: "henry.dupont@tnt.fr",
      sender_phone: "0102030405",
    }
  end

  let(:recipient_attributes) do
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
    }
  end

  let(:expedition_attributes) do
    {
      notify_receiver: false,
      service_code: "JZ",
      saturday_delivery: false,
      shipping_date: get_next_day(Date.today, 2),
      weight: 1.0,
    }
  end

  let(:attributes) do
    sender_attributes
      .merge(recipient_attributes)
      .merge(expedition_attributes)
  end

  let(:valid_attributes) { attributes }
  let(:invalid_attributes) { attributes.merge({ shipping_date: Date.yesterday }) }

  before do
    configure_client
  end

  describe ".request" do
    context "when request name = 'create_shipment'" do
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

      context "when request contains special characters" do
        let(:valid_attributes) { attributes.merge(address_line2: "àéïø") }

        it "returns successful response" do
          VCR.use_cassette('expedition_creation_with_special_characters') do
            response = handler.request(:expedition_creation, valid_attributes)
            expect(response.pdf_labels).to_not be_nil
            expect(response.parcel_number).to_not be_nil
            expect(response.tracking_url).to_not be_nil
          end
        end
      end

      context "with invalid attributes" do
        it "raises a TNTApi::TntError error" do
          VCR.use_cassette('expedition_creation_with_invalid_attributes') do
            expect {
              handler.request(:expedition_creation, invalid_attributes)
            }.to raise_error(TNTApi::TntError, "The field 'shippingDate' is not valid.")
          end
        end

        context "with multiple attributes" do
          let(:invalid_attributes) do
            attributes.merge(
              shipping_date: Date.yesterday,
              address_line1: "",
            )
          end

          it "raises a TNTApi::TntError error with multiple errors in the message" do
            VCR.use_cassette('expedition_creation_with_multiple_invalid_attributes') do
              expect {
                handler.request(:expedition_creation, invalid_attributes)
              }.to raise_error(
                TNTApi::TntError,
                "The field 'receiver.address1' is mandatory. The field 'shippingDate' is not valid.",
              )
            end
          end
        end
      end
    end
  end
end
