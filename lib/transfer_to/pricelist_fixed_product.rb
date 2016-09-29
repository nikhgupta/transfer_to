module TransferToApi
  class PricelistFixedProduct < Product
    attr_reader :product, :retail_price, :wholesale_price

    def initialize(product, retail_price, wholesale_price, skuid, response)
      @product = product
      @retail_price = retail_price
      @wholesale_price = wholesale_price
      super(response)

      @skuid = skuid # Needs to be after the super because it is also set there.
    end

  end
end