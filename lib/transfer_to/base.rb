module TransferToApi
  # This is a base class for the TransferTo API
  class Base
    attr_reader :reply, :request,
    :authentication_key, :error_code, :error_txt, :raw_response


    # This method initializes the base class for API requests.
    #
    # parameters
    # ==========
    # user
    # ----
    # The username to authenticate for requests.
    #
    # password
    # --------
    # The password to authenticate for requests.
    def initialize(user, password)
      aurl     = "https://fm.transfer-to.com:5443"
      @request = ::TransferToApi::Request.new user, password, aurl
    end

    protected
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
    def run_action(name, params = {}, method = :post)
      @request.action = name
      @request.params = params

      @request.run(method).on_complete do |api_reply|
        @raw_response = api_reply
        reply = ::TransferToApi::Reply.new(api_reply)
        raise ::TransferToApi::Error.new reply.error_code, reply.error_message unless reply.success?
        return reply
      end
    end

    def populate(response)
      @authentication_key = response.data[:authentication_key]
      @error_code = response.data[:error_code]
      @error_txt = response.data[:error_txt]
    end

  end
end
