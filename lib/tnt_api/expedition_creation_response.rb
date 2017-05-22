module TntApi
  class ExpedtitionCreationResponse

    Response = struct.new(
      :pdf_labels
      :parcel_number
      :tracking_url
    )

    def initialize(response)
      parse(response)
    end

    private

    def parse(soap_response)
      if soap_response.successful?
        body = soap_response.body[:expedition_creation_response][:expedition]
        response = Response.new
        response.pdf_labels = body[:pdf_labels]
        response.parcel_number = body[:parcel_responses][:parcel_number]
        response.tracking_url = body[:parcel_responses][:tracking_url]
        response
      else
        TntApi::Error.new(error_code: response.http.code, error_description: "Fill in")
      end
    end
  end
end
