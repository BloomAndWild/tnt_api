def configure_client
  TNTApi::Client.configure do |config|
    config.account_number = ENV['ACCOUNT_NUMBER']
    config.username = ENV['USERNAME']
    config.password = ENV['PASSWORD']
    config.logger = Logger.new(STDOUT)
  end
end
