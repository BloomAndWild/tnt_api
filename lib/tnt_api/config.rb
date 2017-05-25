module TNTApi
  class Config
    attr_accessor :service_endpoint, :service_wsdl, :username, :password, :logger,
      :ssl_ca_cert_file, :ssl_cert_file, :ssl_cert_key_file, :account_number
  end
end
