module TntApi
  class ResponseHandler
    class << self
      def handle_response(response, type)
        case type
        when :expedition_creation
          ExpedtitionCreationResponse.new(response).parse
        end
      end
    end
  end
end
