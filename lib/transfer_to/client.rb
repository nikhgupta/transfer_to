module TransferToApi
  class Client
    attr_accessor :username
    attr_accessor :password

    def initialize(username = nil, password = nil)
      @username = username
      @password = password
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
    def run_action(name, params = {}, method = :post)
      aurl     = "https://airtime.transferto.com"

      if @username.nil?
        if TransferToApi.config.username.nil?
          raise TransferToApi::CredentialsException.new
        else
          @username = TransferToApi.config.username
          @password = TransferToApi.config.password
        end
      end

      request = ::TransferToApi::Request.new username, password, aurl

      request.action = name
      request.params = params

      reply = nil
      begin
        request.run(method).on_complete do |api_reply|
          reply = ::TransferToApi::Reply.new(api_reply)
        end
      rescue Faraday::TimeoutError => e
        raise TransferToApi::TimeoutException.new(e.message)
      rescue Faraday::ResourceNotFound => e
        raise TransferToApi::ResourceNotFound.new(e.message)
      rescue => e
        raise TransferToApi::ConnectionException.new(e.message)
      end

      unless reply.status == 200
        raise TransferToApi::ConnectionException.new(reply.raw_response)
      end

      raise TransferToApi::CommandException.new reply.raw_response, reply.error_code, reply.error_message unless reply.success?

      return reply
    end
  end
end
