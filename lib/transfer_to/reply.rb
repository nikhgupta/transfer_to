module TransferToApi
  # This is the response class generated after issuing a request against the
  # TransferTo API.
  class Reply

    # This method initializes a new Reply.
    #
    # parameters
    # ==========
    # reply
    # -----
    # The reply as received from Faraday's request.
    def initialize(reply)
      @response = OpenStruct.new reply.to_hash
    end

    # Starts a pry session for debugging purposes.
    def format_it
      binding.pry
      {
        data: data,
        status: status,
        success: success?,
        method: @response.env[:method],
        url: url,
        headers: headers,
        raw_response: raw
      }
    end

    ######## CONVENIENCE METHODS ##########
    # Convenience method to get the actual data returned by the TransferTo API.
    def data
      hash = {}
      @response.body.lines.each do |line|
        key, value = line.strip.split "="
        hash[key.to_sym] = (key == "error_code") ? value.to_i : value
      end; hash
    end

    # Convenience method to get the response status from the TransferTo API.
    def status
      @response.status
    end

    # Convenience method to read the error_code returned by the TransferTo API.
    def error_code
      data[:error_code]
    end

    # Convenience method to read the error_message returned by the TransferTo API.
    def error_message
      data[:error_txt]
    end

    # Convenience method to determine whether the request was successful.
    def success?
      status == 200 && error_code == 0
    end

    # Convenience method to read the url used in the TransferTo API.
    def url
      @response.env[:url].to_s
    end

    # Convenience method to read information
    def information
      data.reject do |key, value|
        [:authentication_key, :error_code, :error_txt].include?(key)
      end
    end

    # Convenience method to read the information returned by the TransferTo API.
    def message
      information[:info_txt]
    end

    # Convenience method to read the authentication key used by the TransferTo API.
    def auth_key
      data[:authentication_key]
    end

    # Convenience method to read headers returned by the TransferTo API.
    def headers
      @response.headers
    end

    # Convenience method to read the whole response body returned by the TransferTo API.
    def raw
      @response.body
    end
  end
end
