module TransferToApi
  class Product
    attr_reader :operator, :destination_currency

    def initialize(response)
      @operator = TransferToApi::Operator.new(response.data[:country], response.data[:countryid], response.data[:operator], response.data[:operatorid])
      @destination_currency = response.data[:destination_currency]
    end
  end
end