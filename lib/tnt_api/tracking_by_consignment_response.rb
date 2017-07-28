module TNTApi
  class TrackingByConsignmentResponse

    def initialize(response)
      response.body[:tracking_by_consignment_response][:parcel]
    end
  end
end
