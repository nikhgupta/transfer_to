module TransferToApi
  # This is a base class for the TransferTo API
  class Base

    @@username
    @@password

    attr_reader :authentication_key, :error_code, :error_txt, :raw_response

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

      # CgConfig::TRANSFER2[:bla]

      request.action = name
      request.params = params

      reply = nil
      begin
        request.run(method).on_complete do |api_reply|
          reply = ::TransferToApi::Reply.new(api_reply)
        end
      rescue Faraday::TimeoutError => e
        raise TransferToApi::TimeoutException.new
      rescue Faraday::ResourceNotFound => e
        raise TransferToApi::ResourceNotFound.new
      rescue
        raise TransferToApi::ConnectionException.new
      end

      unless reply.status == 200
        raise TransferToApi::ConnectionException.new(reply.raw_response)
      end

      raise TransferToApi::CommandException.new reply.raw_response, reply.error_code, reply.error_message unless reply.success?

      return reply

    end

    def initialize(response)
      @authentication_key = response.data[:authentication_key]
      @error_code = response.data[:error_code]
      @error_txt = response.data[:error_txt]
      @raw_response = response.raw_response
    end

  end
end
