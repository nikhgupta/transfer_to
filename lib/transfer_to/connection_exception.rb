module TransferToApi
  class ConnectionException < RuntimeError

    attr_reader :raw_response

    def initialize(raw_response=nil)
      @raw_response = raw_response
    end
  end
  class TimeoutException < ConnectionException; end
  class ResourceNotFound < ConnectionException; end
end