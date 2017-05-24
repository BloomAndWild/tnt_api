def configure_client
  TNTApi::Client.configure do |config|
    config.shipping_endpoint = "http://www.tnt.fr/service/"
    config.username = ENV['USERNAME']
    config.password = ENV['PASSWORD']
    config.account_number = ENV['ACCOUNT_NUMBER']
    config.logger = Logger.new(STDOUT)
  end
end
