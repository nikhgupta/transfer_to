module TransferToApi
  class PricelistFixedProduct < Product
    attr_reader :product, :retail_price, :wholesale_price

    def initialize(product, retail_price, wholesale_price, response)
      @product = product
      @retail_price = retail_price
      @wholesale_price = wholesale_price
      super(response)
    end

  end
end