module TransferToApi
  class Product
    attr_reader :country, :country_id, :operator_name, :operator_id, :destination_currency

    def initialize(response)
      @country = response.data[:country]
      @country_id = response.data[:countryid]
      @operator_name = response.data[:operator]
      @operator_id = response.data[:operatorid]
      @destination_currency = response.data[:destination_currency]
    end
  end
end