module TNTApi
  class ExpedtitionCreationResponse

    attr_accessor :pdf_labels, :parcel_number, :tracking_url

    def initialize(response)
      body = response.body[:expedition_creation_response][:expedition]
      @pdf_labels = body[:pdf_labels]
      @parcel_number = body[:parcel_responses][:parcel_number]
      @tracking_url = body[:parcel_responses][:tracking_url]
    end
  end
end
