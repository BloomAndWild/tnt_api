module TntApi
  class Config
    attr_accessor :shipping_endpoint, :username, :password, :logger,
      :ssl_ca_cert_file, :ssl_cert_file, :ssl_cert_key_file, :account_number
  end
end
