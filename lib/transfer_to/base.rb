module TransferToApi
  # This is a base class for the TransferTo API
  class Base

    @@username
    @@password

    attr_reader :authentication_key, :error_code, :error_txt

    def self.login(username, password)
      @@username = username
      @@password = password
      self
    end

    # This method can be used to run a specific action against the TransferTo API.
    #
    # parameters
    # ==========
    # name
    # ----
    # The name of the method you want to issue against the API.
    #
    # parameters
    # ----------
    # Default: {}
    # An object with all parameters, specific to the requested method.
    #
    # method
    # ------
    # Default: get
    # Determines the type of request issued (get|post).
    def self.run_action(name, params = {}, method = :post)
      aurl     = "https://fm.transfer-to.com:5443"
      request = ::TransferToApi::Request.new @@username, @@password, aurl

      request.action = name
      request.params = params

      request.run(method).on_complete do |api_reply|
        reply = ::TransferToApi::Reply.new(api_reply)
        raise ::TransferToApi::Error.new reply.error_code, reply.error_message unless reply.success?
        return reply
      end
    end

    def initialize(response)
      @authentication_key = response.data[:authentication_key]
      @error_code = response.data[:error_code]
      @error_txt = response.data[:error_txt]
    end

  end
end
