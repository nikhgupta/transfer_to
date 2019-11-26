module TransferToApi
  # This is the request class to issue requests against the TransferTo API.
  class Request

    READ_TIMEOUT = 30
    OPEN_TIMEOUT = 5

    attr_reader :user, :name, :params

    # Initializes a new request with a username, password and authentication url.
    def initialize(user, password, aurl = nil)
      @user   = user
      @pass   = password
      @conn = Faraday.new(url: aurl) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  :net_http
      end
    end

    # Resets the connection, and generates an updated hash with a new key.
    def reset
      @params = {}
      authenticate
    end

    # This method sets up the authentication parameters.
    def authenticate
      time = Time.now.to_i.to_s
      key = time + Random.rand(9999999999).to_s
      add_param :key,   key
      add_param :md5,   md5_hash(@user + @pass + key)
      add_param :login, @user
    end

    # This method defines the action to be performed against the TransferTo API.
    #
    # parameters
    # ==========
    # name
    # ----
    # The name of the action to be performed.
    def action=(name)
      reset
      @name = name
      add_param :action, name
    end

    # This method merges new parameters to be used in subsequent requests.
    #
    # parameters
    # ==========
    # parameters
    # ----------
    # The parameters to be merged in the request.
    def params=(parameters)
      @params.merge!(parameters)
    end

    # This method adds a new parameter to be used in subsequent requests.
    #
    # parameters
    # ==========
    # key
    # ---
    # The identifier / name of the parameter
    #
    # value
    # -----
    # The actual value for the parameter
    def add_param(key, value)
      @params[key.to_sym] = value
    end

    # This method returns the key used in the request.
    def key
      @params[:key]
    end

    # Determines if the request will be performed as a GET request.
    def get?
      @params[:method] == :get
    end

    # Determines if the request will be perfomed as a POST request.
    def post?
      @params[:method] == :post
    end

    # This method runs the actual action against the API
    def run(method = :get)
      add_param :method, method
      @conn.send(method, "/cgi-bin/shop/topup", @params) do |req|
        req.options.timeout = READ_TIMEOUT
        req.options.open_timeout = OPEN_TIMEOUT
      end
    end

    private
    def md5_hash(str)
      (Digest::MD5.new << str).to_s
    end

    def to_time(time)
      case time.class.name
      when "String"  then return Time.parse(time)
      when "Integer" then return Time.at(time)
      when "Time"    then return time
      else raise ArgumentError
      end
    rescue
      Time.now
    end

    def to_yyyymmdd(time)
      to_time(time).strftime("%Y-%m-%d")
    end
  end
end
