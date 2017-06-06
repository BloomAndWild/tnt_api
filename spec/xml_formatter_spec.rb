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

    it "formats special chars to html decimal entities" do
      expect(subject[:first_name]).to eq "&amp;#233;&amp;#229;&amp;#248;&amp;#238;&amp;#252;&amp;#38;"
    end

    it "escapes XML special chars" do
      expect(subject[:last_name]).to eq "&amp;#38;&amp;#60;&amp;#62;&amp;#39;"
    end

    it "only html encodes string attrs" do
      expect(subject[:zip_code]).to eq 19290
      expect(subject[:notify_receiver]).to eq false
    end

    it "formats dates to strings" do
      expect(subject[:shipping_date]).to eq attrs[:shipping_date].to_s
    end
  end
end
