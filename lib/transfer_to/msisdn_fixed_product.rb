module TransferToApi
  class MsisdnFixedProduct
    attr_reader :product, :retail_price, :wholesale_price, :skuid, :local_value,
    :local_amount

    def initialize(product, retail_price, wholesale_price, skuid, local_value, local_amount)
      @product = product
      @retail_price = retail_price
      @wholesale_price = wholesale_price
      @skuid = skuid
      @local_value = local_value
      @local_amount = local_amount
    end

  end
end