require 'spec_helper'

describe TNTApi::XMLFormatter  do
  describe ".format_attrs" do
    let(:attrs) do
      {
        first_name: "éåøîü&",
        last_name: "&<>'",
        zip_code: 19290,
        notify_receiver: false,
        shipping_date: get_next_day(Date.today, 2),
      }
    end

    subject { described_class.format_attrs(attrs) }

    describe "special characters" do
      describe "authorized special characters" do
        let(:composed_special_characters) do
          "àâäéèêëîïôöùûüñÀÂÄÉÈÊËÎÏÔÖÙÛÜÑÇç"
        end
        let(:decomposed_special_characters) do
          "àâäéèêëîïôöùûüñÀÂÄÉÈÊËÎÏÔÖÙÛÜÑÇç"
        end

        describe 'when unicode composed' do
          before do
            attrs[:address_line2] = composed_special_characters
          end

          it 'should not modify the characters' do
            expect(subject[:address_line2]).to eq(composed_special_characters)
          end
        end

        describe 'when unicode decomposed' do
          before do
            attrs[:address_line2] = decomposed_special_characters
          end

          it 'should compose the characters' do
            expect(subject[:address_line2]).to eq(composed_special_characters)
          end
        end
      end

      xdescribe "unauthorized special characters" do
        let(:special_characters) do
          ""
        end
        it "converts to html decimal entities" do
          #TODO
        end
      end

      describe "XML special characters" do
        it "converts to html entities" do
          expect(subject[:last_name]).to eq "&amp;&lt;&gt;&apos;"
        end
      end
    end

    it "doesn't modify integer attrs" do
      expect(subject[:zip_code]).to eq 19290
    end

    it "doesn't modify boolean attrs" do
      expect(subject[:notify_receiver]).to eq false
    end

    it "formats dates to strings" do
      expect(subject[:shipping_date]).to eq attrs[:shipping_date].to_s
    end
  end
end
