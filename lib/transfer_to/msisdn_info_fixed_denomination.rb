module TransferToApi
  class MsisdnInfoFixedDenomination < MsisdnInfo

    attr_reader :requested_currency, :local_info_currency, :products

    def initialize(response)
      @requested_currency = response.data[:requested_currency]
      @local_info_currency = response.data[:local_info_currency]
      product_list = response.data[:product_list].split(',')
      retail_price_list = response.data[:retail_price_list].split(',')
      wholesale_price_list = response.data[:wholesale_price_list].split(',')
      skuid_list = response.data[:skuid_list].split(',')
      local_info_value_list = response.data[:local_info_value_list].split(',')
      local_info_amount_list = response.data[:local_info_amount_list].split(',')

      @products = []
      product_list.count.times do |count|
        @products << TransferToApi::FixedProduct.new(
          product_list[count],
          retail_price_list[count],
          wholesale_price_list[count],
          skuid_list[count],
          local_info_value_list[count],
          local_info_amount_list[count]
        )
      end

      super(response)
    end
  end
end



