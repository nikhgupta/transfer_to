module TransferToApi
  class MsisdnInfoOpenRange < MsisdnInfo

    attr_reader :minimum_amount_local_currency,
      :maximum_amount_local_currency, :minimum_amount_requested_currency,
      :maximum_amount_requested_currency, :increment_local_currency,
      :requested_currency, :skuid

    def initialize(response)
      @minimum_amount_local_currency = response.data[:open_range_minimum_amount_local_currency]
      @maximum_amount_local_currency = response.data[:open_range_maximum_amount_local_currency]
      @minimum_amount_requested_currency = response.data[:open_range_minimum_amount_requested_currency]
      @maximum_amount_requested_currency = response.data[:open_range_maximum_amount_requested_currency]
      @increment_local_currency = response.data[:open_range_increment_local_currency]
      @requested_currency = response.data[:open_range_requested_currency]
      @skuid = response.data[:skuid]
      super(response)
    end

  end
end


