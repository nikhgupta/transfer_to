module TransferToApi
  class Product
    attr_reader :operator, :destination_currency, :skuid, :open_range,
    :product_type, :fx_local_currency, :fx_rate

    def initialize(response)
      @open_range = response.data[:open_range] || "0"
      @operator = TransferToApi::Operator.new(response.data[:country],
                                              response.data[:countryid],
                                              response.data[:operator],
                                              response.data[:operatorid])
      @destination_currency = response.data[:destination_currency]
      @skuid = response.data[:skuid]
      @product_type = response.data[:product_type]
      @fx_local_currency = response.data[:fx_local_currency]
      @fx_rate = response.data[:fx_rate]
    end

    # product_type seems to be either 'Airtime PIN Based' or 'Airtime PIN Less'
    def is_pin_based?
      @product_type.include?('PIN Based')
    end
  end
end
