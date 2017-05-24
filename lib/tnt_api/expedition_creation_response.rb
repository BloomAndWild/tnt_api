module TNTApi
  class ExpedtitionCreationResponse

    attr_accessor :object

    Response = Struct.new(
      :pdf_labels,
      :parcel_number,
      :tracking_url
    )

    def initialize(response)
      @object = parse(response)
    end

    private

    def parse(soap_response)
      body = soap_response.body[:expedition_creation_response][:expedition]
      response = Response.new
      response.pdf_labels = body[:pdf_labels]
      response.parcel_number = body[:parcel_responses][:parcel_number]
      response.tracking_url = body[:parcel_responses][:tracking_url]
      response
    end
  end
end
