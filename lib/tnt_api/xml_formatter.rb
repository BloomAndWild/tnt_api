module TNTApi
  class XMLFormatter
    XML_SPECIAL_CHARACTER_MAP = {
      '"' => "&quot;",
      "&" => "&amp;",
      "'" => "&apos;",
      "<" => "&lt;",
      ">" => "&gt;",
    }.freeze

    class << self
      def format_attrs(attrs)
        new.format_attrs(attrs)
      end
    end

    def format_attrs(attrs)
      attrs.merge!(shipping_date: formatted_date(attrs[:shipping_date]))

      attrs.each do |k, v|
        next unless v.is_a?(String)

        attrs[k] = escape_xml_chars(
          html_encoder.encode(v, :decimal)
        )
      end

      attrs
    end

    private

    def formatted_date(shipping_date)
      if shipping_date.is_a?(Date)
        shipping_date.to_s
      else
        shipping_date
      end
    end

    def escape_xml_chars(str)
      return str unless str.is_a? String
      str.gsub(/["&'<>]/, XML_SPECIAL_CHARACTER_MAP)
    end

    def html_encoder
      HTMLEntities.new
    end
  end
end
