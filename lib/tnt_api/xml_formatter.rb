module TNTApi
  class XMLFormatter
    XML_SPECIAL_CHARACTER_MAP = {
      '"' => "&quot;",
      "&" => "&amp;",
      "'" => "&apos;",
      "<" => "&lt;",
      ">" => "&gt;",
    }.freeze

    UNAUTHORIZED_CHARACTERS_REGEX = /[^A-Z0-9àâäéèêëîïôöùûüñÀÂÄÉÈÊËÎÏÔÖÙÛÜÑ 2&"#'{}()\[\]|_\\\/Çç^@°=+\-£$¤%μ*<>?,\.;:§!]/i.freeze

    class << self
      def format_attrs(attrs)
        new.format_attrs(attrs)
      end
    end

    def format_attrs(attrs)
      attrs.each do |k, v|
        case v.class.name
        when "String"
          attrs[k] = format_string(v)
        when "Date"
          attrs[k] = v.to_s
        end
      end

      attrs
    end

    private

    def format_string(str)
      return str unless str.is_a? String
      escape_xml_chars(
          encode_unauthorized_chars(
            str.unicode_normalize
          )
        )
    end

    def encode_unauthorized_chars(str)
      str.gsub(UNAUTHORIZED_CHARACTERS_REGEX) do |v|
        "&##{v.ord};"
      end
    end

    def escape_xml_chars(str)
      str.gsub(/["&'<>]/, XML_SPECIAL_CHARACTER_MAP)
    end
  end
end
