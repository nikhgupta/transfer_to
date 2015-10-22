module TransferTo
  class Base

    attr_reader :reply, :request

    TEST_NUMBERS = { one:   "628123456710",
                     two:   "628123456770",
                     three: "628123456780",
                     four:  "628123456781",
                     five:  "628123456790",
                     six:   "628123456798",
                     seven: "628123456799"
                   }

    def initialize(user, password)
      aurl     = "https://fm.transfer-to.com:5443"
      @request = ::TransferTo::Request.new user, password, aurl
    end

    def run_action(name, params = {}, method = :get)

      @request.action = name
      @request.params = params

      @request.run(method).on_complete do |api_reply|
        reply = ::TransferTo::Reply.new(api_reply)
        raise ::TransferTo::Error.new reply.error_code, reply.error_message unless reply.success?
        return reply
      end
    end
  end
end
