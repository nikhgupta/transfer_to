module TransferTo
  class Request

    attr_reader :user, :name, :params

    def initialize(user, password, aurl = nil)
      @user   = user
      @pass   = password
      @conn = Faraday.new(url: aurl) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  :net_http
      end
    end

    def reset
      @params = {}
      authenticate
    end

    def authenticate
      time = Time.now.to_i.to_s
      add_param :key,   time
      add_param :md5,   md5_hash(@user + @pass + time.to_s)
      add_param :login, @user
    end

    def action=(name)
      reset
      @name = name
      add_param :action, name
    end

    def params=(parameters)
      @params.merge!(parameters)
    end

    def add_param(key, value)
      @params[key.to_sym] = value
    end

    def key
      @params[:key]
    end

    def get?
      @params[:method] == :get
    end

    def post?
      @params[:method] == :post
    end

    def run(method = :get)
      add_param :method, method
      @conn.send(method, "/cgi-bin/shop/topup", @params) do |req|
        req.options = { timeout: 600, open_timeout: 600 }
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
