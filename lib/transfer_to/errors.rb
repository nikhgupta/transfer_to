module TransferToApi
  # This is a wrapper class for TransferTo Error codes.
  class Error < StandardError

    attr_reader :code

    # This method is used to instantiate a new Error object with a response code
    # from the API.
    def initialize(code, message = nil)
      @code = code.to_i
      super(message)
    end
  end
end
