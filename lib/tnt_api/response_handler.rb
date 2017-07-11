module TNTApi
  class ResponseHandler
    class << self
      def handle_response(response, type)
        new(response, type).handle_response
      end
    end

    def initialize(response, type)
      @response = response
      @type = type
    end

    def handle_response
      case type
      when :expedition_creation
        ExpeditionCreationResponse.new(response)
      end
    end

    private

    attr_reader :response, :type
  end
end
