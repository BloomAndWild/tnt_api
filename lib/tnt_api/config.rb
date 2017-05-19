module TntApi
  class Config
    attr_accessor :username,
      :password,
      :adapter,
      :shipping_endpoint,
      :logger
  end
end
