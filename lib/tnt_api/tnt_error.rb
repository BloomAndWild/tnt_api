module TNTApi
  class TntError < StandardError
    attr_accessor :xml, :code

    def initialize(args)
      raise ArgumentError 'tnt error must be initialized with a hash' unless args.is_a? Hash
      raise ArgumentError 'error must contain some information' unless args.present?
      @xml = args[:xml]
      @code = args[:error_code]
      super(message)
    end

    def message
      parser = TNTApi::XMLParser.new
      parser.parse_text(@xml, "faultstring")[0..-2].gsub(/\R/, ' ')
    end
  end
end
