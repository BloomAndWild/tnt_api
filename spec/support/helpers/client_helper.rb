def configure_client
  TntApi::Client.configure do |config|
    config.shipping_endpoint = "http://www.tnt.fr/service/"
    config.username = "webservices@tnt.fr"
    config.password = "test"
    config.logger = Logger.new(STDOUT)
    config.ssl_ca_cert_file = File.join(TntApi.root_path, 'tmp', 'certs', 'cacert.pem')
    config.ssl_cert_file = File.join(TntApi.root_path, 'tmp', 'certs', 'mycert.pem')
    config.ssl_cert_key_file = File.join(TntApi.root_path, 'tmp', 'certs', 'mykey.pem')
  end
end
