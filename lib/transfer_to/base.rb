module TransferTo
  class Base

    attr_reader :reply, :request

    def initialize(user, password)
      aurl     = "https://fm.transfer-to.com:5443"
      @params  = {}
      @request = ::TransferTo::Request.new user, password, aurl
    end

    def run_action(name, method = :get)

      @request.action = name
      @request.params = @params

      @request.run(method).on_complete do |reply|
        @reply = ::TransferTo::Reply.new(reply)
        raise ::TransferTo::Error.new @reply.error_code, @reply.error_message unless @reply.success?
        return @reply
      end
    end

    def test_numbers(num = nil)
      numbers = [ "628123456710", "628123456770", "628123456780",
                  "628123456781", "628123456790", "628123456798",
                  "628123456799" ]
      num > 0 && num < 8 ? numbers[num-1] : numbers
    end
  end
end
