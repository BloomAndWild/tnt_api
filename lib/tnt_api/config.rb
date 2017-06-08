module TNTApi
  class Config
    attr_writer :service_endpoint, :service_wsdl
    attr_accessor :username, :password, :logger, :account_number

    def service_wsdl
      @service_wsdl ||= "https://www.tnt.fr/service/?wsdl"
    end

    def service_endpoint
      @service_endpoint ||= "http://www.tnt.fr/service/"
    end
  end
end
