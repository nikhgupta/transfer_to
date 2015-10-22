module TransferTo
  class Reply

    # "reply" as received from Faraday's request
    def initialize(reply)
      @response = OpenStruct.new reply.to_hash
    end

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

    # get the actual data returned by the TransferTo API
    def data
      hash = {}
      @response.body.lines.each do |line|
        key, value = line.strip.split "="
        hash[key.to_sym] = (key == "error_code") ? value.to_i : value
      end; hash
    end

    def status
      @response.status
    end

    def error_code
      data[:error_code]
    end

    def error_message
      data[:error_txt]
    end

    def success?
      status == 200 && error_code == 0
    end

    def url
      @response.env[:url].to_s
    end

    def information
      data.reject do |key, value|
        [:authentication_key, :error_code, :error_txt].include?(key)
      end
    end

    def message
      information[:info_txt]
    end

    def auth_key
      data[:authentication_key]
    end

    def headers
      @response.headers
    end

    def raw
      @response.body
    end
  end
end
