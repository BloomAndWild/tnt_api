require 'openssl'
require 'base64'
require 'savon'
require 'digest/sha1'
require "active_support/core_ext/string"
require 'htmlentities'

require "tnt_api/version"
require "tnt_api/client"
require "tnt_api/config"
require "tnt_api/tnt_error"
require "tnt_api/request_handler"
require "tnt_api/response_handler"
require "tnt_api/expedition_creation_response"
require "tnt_api/xml_builder"
require "tnt_api/xml_parser"

module TNTApi
  def self.root_path
    File.dirname __dir__
  end
end
