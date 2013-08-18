module TransferTo
  class Error < StandardError
    attr_reader :code
    def initialize(code, message = nil)
      @code = code.to_i
      super(message)
    end
  end
end
