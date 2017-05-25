module TNTApi
  class RequestHandler
    class << self
      def request(request_name, attrs={})
        begin
          handler = TNTApi::RequestHandler.new(request_name)
          xml = handler.build_xml(attrs)
          tnt_response = handler.savon.call(request_name, xml: xml)
          TNTApi::ResponseHandler.handle_response(tnt_response, request_name)
        rescue Savon::SOAPFault => e
          raise TNTApi::SoapError.new(xml: e.xml, error_code: e.http.code)
        end
      end

      def config
        Client.config
      end
    end

    def initialize(request_name)
      @request_name = request_name
    end

    def build_xml(attrs={})
      TNTApi::XmlBuilder.new(request_name, attrs.merge(security_attrs), request_type).build
    end

    def savon
      Savon.client(
        adapter: :httpclient,
        wsdl: wsdl,
        endpoint: endpoint,
        namespace: endpoint,
        ssl_ca_cert_file: config.ssl_ca_cert_file,
        ssl_cert_file: config.ssl_cert_file,
        ssl_cert_key_file: config.ssl_cert_key_file,
        open_timeout: 600,
        read_timeout: 600,
        logger: config.logger,
        log_level: config.logger.level.zero? ? :debug : :info,
        log: config.logger.level.zero?,
        pretty_print_xml: true,
      )
    end

    private
    attr_accessor :request_name

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

    def config
      self.class.config
    end
  end
end
