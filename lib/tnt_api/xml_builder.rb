require 'erb'
require 'ostruct'

module TNTApi
  class XMLBuilder < OpenStruct
    attr_reader :request, :type

    def initialize(request, attrs={}, type='shipping')
      @request = request
      @type = type

      formatted_attrs = TNTApi::XMLFormatter.format_attrs(attrs)
      super formatted_attrs
    end

    def build
      envelope
    end

    private

    def xml_path
      [TNTApi.root_path, 'lib', 'xml']
    end

    def build_xml(file)
      path = File.join(xml_path << file)
      ERB.new(File.read(path)).result(binding)
    end

    def header
      build_xml('security_header.xml')
    end

    def body
      build_xml("#{request}.xml")
    end

    def envelope
      build_xml("#{type}_envelope.xml")
    end
  end
end
