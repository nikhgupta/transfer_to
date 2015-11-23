module TransferToApi
  class ConnectionException < RuntimeError
    def initialize(exception)
    end
  end
  class TimeoutException < ConnectionException; end
  class ResourceNotFound < ConnectionException; end
end