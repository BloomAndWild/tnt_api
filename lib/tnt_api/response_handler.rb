module TNTApi
  class ResponseHandler
    class << self
      def handle_response(response, type)
        case type
        when :expedition_creation
          ExpedtitionCreationResponse.new(response)
        end
      end
    end
  end
end
