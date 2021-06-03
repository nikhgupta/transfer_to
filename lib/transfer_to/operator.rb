module TransferToApi
  class Operator
    attr_reader :country, :name, :id

    def initialize(country_name, country_id, name, id)
      @country = TransferToApi::Country.new(country_name, country_id)
      @name = name
      @id = id
    end

  end
end
