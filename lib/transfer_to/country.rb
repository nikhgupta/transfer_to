module TransferToApi
  class Country
    attr_reader :name, :id

    def initialize(name, id)
      @name = name
      @id = id
    end

  end
end