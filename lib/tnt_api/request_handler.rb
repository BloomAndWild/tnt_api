module TNTApi
  class RequestHandler
    class << self
      def request(request_name, attrs)
        new(request_name, attrs).request
      end
    end

    def initialize(request_name, attrs)
      @request_name = request_name
      @attrs = attrs
    end

    def request
      xml = xml_builer(attrs.merge(security_attrs)).build

      tnt_response = savon.call(request_name, xml: xml)
      TNTApi::ResponseHandler.handle_response(tnt_response, request_name)
    rescue Savon::SOAPFault => e
      raise TNTApi::TntError.new(
        xml: e.xml,
        attrs: xml_builer.to_h.except(*security_attrs.keys),
        error_code: e.http.code
      )
    end

    def config
      Client.config
    end

    def xml_builer(attrs={})
      @xml_builder ||= TNTApi::XMLBuilder.new(request_name, attrs, request_type)
    end

    def savon
      Savon.client(
        adapter: :httpclient,
        wsdl: wsdl,
        endpoint: endpoint,
        namespace: endpoint,
        open_timeout: 600,
        read_timeout: 600,
        logger: config.logger,
        log_level: config.logger.level.zero? ? :debug : :info,
        log: config.logger.level.zero?,
        pretty_print_xml: true,
      )
    end

    private
    attr_accessor :request_name, :attrs

    def request_type
      case request_name
      when :expedition_creation
        'shipping'
      else
        error_message = "Request type #{request_name} is not supported"
        config.logger&.debug(error_message)
        raise ArgumentError error_message
      end
    end

    def wsdl
      case request_type
      when "shipping"
        config.service_wsdl
      end
    end

    def endpoint
      case request_type
      when "shipping"
        config.service_endpoint
      end
    end

    def security_attrs
      {
        username: config.username,
        password: config.password,
        account_number: config.account_number,
      }
    end
  end
end
