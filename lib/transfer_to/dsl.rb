module TransferToApi
  # This class provides domain specific methods as wrappers over the API class
  class DSL < Client

    # check the status of the TranferTo API
    def check_status
      self.ping
      reply.success? && reply.message == "pong" && reply.auth_key == request.key
    end

    # get information about a phone number
    def phone_search(number, operator_id = nil)
      information = msisdn_info(number, operator_id).information
      information[:product_list] = information[:product_list].split(",")
      information
    end
  end
end
