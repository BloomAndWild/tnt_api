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
      address_line2: "to be encoded: ~",
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
      receiver_type: "INDIVIDUAL",
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

  let(:valid_parcel_number) { "9412345000000025" }
  let(:invalid_parcel_number) { "?" }

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

      describe "authorized special characters" do
        context "when a field contains 32 decomposed unicode characters" do
          # decomposed characters are represented as a two unicode values (letter + accent)
          # therefore the string below has a length of 64
          let(:valid_attributes) { attributes.merge(address_line2: "àâäéèêëîïôöùûüñÀÂÄÉÈÊËÎÏÔÖÙÛÜÑÇç") }

          it "returns successful response" do
            VCR.use_cassette('expedition_creation_with_decomposed_special_characters') do
              response = handler.request(:expedition_creation, valid_attributes)
              expect(response.pdf_labels).to_not be_nil
              expect(response.parcel_number).to_not be_nil
              expect(response.tracking_url).to_not be_nil
            end
          end
        end

        context "when a field contains 32 composed unicode characters" do
          # precomposed characters are represented as a single unicode value
          let(:valid_attributes) { attributes.merge(address_line2: "àâäéèêëîïôöùûüñÀÂÄÉÈÊËÎÏÔÖÙÛÜÑÇç") }

          it "returns successful response" do
            VCR.use_cassette('expedition_creation_with_composed_special_characters') do
              response = handler.request(:expedition_creation, valid_attributes)
              expect(response.pdf_labels).to_not be_nil
              expect(response.parcel_number).to_not be_nil
              expect(response.tracking_url).to_not be_nil
            end
          end
        end
      end

      describe "unauthorized characters" do
        let(:valid_attributes) { attributes.merge(address_line2: "~`¢") }

        it 'returns a successful response' do
          VCR.use_cassette('expedition_creation_with_unauthorized_characters') do
            response = handler.request(:expedition_creation, valid_attributes)
            expect(response.pdf_labels).to_not be_nil
            expect(response.parcel_number).to_not be_nil
            expect(response.tracking_url).to_not be_nil
          end
        end
      end

      context "with invalid attributes" do
        it "raises a TNTApi::TNTError error" do
          VCR.use_cassette('expedition_creation_with_invalid_attributes') do
            expect {
              handler.request(:expedition_creation, invalid_attributes)
            }.to raise_error(TNTApi::TNTError, "The field 'shippingDate' is not valid.")
          end
        end

        it "should assign request attributes for debugging" do
          VCR.use_cassette('expedition_creation_with_invalid_attributes') do
            begin
              handler.request(:expedition_creation, invalid_attributes)
            rescue TNTApi::TNTError => error
              expect(error.attributes[:address_line2]).to eq("to be encoded: &amp;#126;")
            end
          end
        end

        context "with multiple attributes" do
          let(:invalid_attributes) do
            attributes.merge(
              shipping_date: Date.yesterday,
              address_line1: "",
            )
          end

          it "raises a TNTApi::TNTError error with multiple errors in the message" do
            VCR.use_cassette('expedition_creation_with_multiple_invalid_attributes') do
              expect {
                handler.request(:expedition_creation, invalid_attributes)
              }.to raise_error(
                TNTApi::TNTError,
                "The field 'receiver.address1' is mandatory. The field 'shippingDate' is not valid.",
              )
            end
          end
        end
      end
    end

    context "when request name = 'tracking_by_consignment'" do
      context "with valid parcel number" do
        it "returns successful response", :focus do
          VCR.use_cassette('tracking_by_consignment_with_valid_parcel_number') do
            response = handler.request(:tracking_by_consignment, { parcel_number: "7516717000003642" })
            expect(response).to be_a TNTApi::TrackingByConsignmentResponse

            expect(response.tracking_data).to eq(
              :account_number => "08994183",
              :consignment_number => "7516717000003642",
              :events => {
                :arrival_center => "ALFORTVILLE",
                :arrival_center_pex => "0401",
                :arrival_date => "2017-08-01 04:46:00",
                :delivery_date => "2017-08-01 10:43:00",
                :delivery_departure_center => "ALFORTVILLE",
                :delivery_departure_center_pex => "0401",
                :delivery_departure_date => "2017-08-01 07:56:00",
                :process_center => "LE MANS",
                :process_center_pex => "0308",
                :process_date => "2017-07-31 18:38:00",
                :request_date => "2017-07-31 02:25:00"
              },
              :long_status => ["Votre colis a été livré le 01/08/2017 à 10:43", "Réceptionné par : stella et dot  - Stella & Dot France"],
              :primary_pod_url => "https://portail.tnt.oxiged.com/Display.tnt?CDBEAEEKEFFAHCFKEFFDFCFBEFGDEFECGGFJHFEAEEBGAECEAAESFDFKEJGEFMEDFAFRFCCAAJBMADDSARBHHSBFAHDKEJDFBNBFAJFPFHENHN",
              :receiver => {
                :address1 => "19 Rue Vivienne",
                :city => "PARIS 02",
                :zip_code => "75002",
                :country => "FR",
                :department => "75",
                :name => "Stella & Dot France"
              },
              :reference => nil,
              :sender => {
                :address1 => "Les Mardelles",
                :city => "ALLONNES",
                :zip_code => "72700",
                :country => "FR",
                :department => "72",
                :name => "Bloom & Wild/Bigot"
              },
              :service => "Express LPSE",
              :short_status => "Livré",
              :status_code => "000",
              :weight => "1.2"
            )
          end
        end
      end
      context "with invalid parcel number" do
        it "returns error response" do
          VCR.use_cassette('tracking_by_consignment_with_invalid_parcel_number') do
            expect {
              handler.request(:tracking_by_consignment, { parcel_number: invalid_parcel_number })
            }.to raise_error(
              TNTApi::TNTError,
              "The field 'parcelNumber' has an invalid size. Valid is 16 characters.",
            )
          end
        end
      end
      context "without parcel number" do
        it "returns error response" do
          VCR.use_cassette('tracking_by_consignment_without_parcel_number') do
            expect {
              handler.request(:tracking_by_consignment, { parcel_number: ""})
            }.to raise_error(
              TNTApi::TNTError, "The field 'parcelNumber' is mandatory.",
            )
          end
        end
      end
    end
  end
end
