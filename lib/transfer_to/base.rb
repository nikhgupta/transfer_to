module TransferToApi
  # This is a base class for the TransferTo API
  class Base
    attr_reader :authentication_key, :error_code, :error_txt, :raw_response

    def self.login(*args)
      ActiveSupport::Deprecation.warn('The login method is no longer used. Please use the TransferToApi::Client for this')
      self
    end

    def initialize(response)
      @authentication_key = response.data[:authentication_key]
      @error_code = response.data[:error_code]
      @error_txt = response.data[:error_txt]
      @raw_response = response.raw_response
    end

  end
end
