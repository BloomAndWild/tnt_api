def configure_client
  TNTApi::Client.configure do |config|
    config.account_number = ENV['ACCOUNT_NUMBER']
    config.username = ENV['USERNAME']
    config.password = ENV['PASSWORD']
    config.logger = Logger.new(STDOUT)
    config.service_endpoint = "http://www.tnt.fr/service/"
    config.service_wsdl  = "https://www.tnt.fr/service/?wsdl"
  end
end
