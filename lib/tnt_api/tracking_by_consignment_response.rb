module TNTApi
  class TrackingByConsignmentResponse
    def initialize(response)
      @response = response.body[:tracking_by_consignment_response]
    end

    def tracking_data
      @tracking_data = response[:parcel]
    end

    private

    attr_reader :response
  end
end
