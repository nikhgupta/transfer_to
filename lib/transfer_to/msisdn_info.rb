module TransferToApi
  class MsisdnInfo < Base

    attr_reader :operator, :connection_status, :destination_msisdn, :destination_currency, :open_range

    # This method is used to retrieve various information of a specific MSISDN
    # (operator, country…) as well as the list of all products configured for
    # your specific account and the destination operator of the MSISDN.
    def self.get(*args)
      args.prepend(TransferToApi::Client.new)
      self.send(:get_from_client, *args)
    end

    def self.get_from_client(client, phone_number, currency = 'USD', operator_id=nil)
      params = {
        destination_msisdn: phone_number,
        currency: currency,
        delivered_amount_info: "1",
        return_service_fee: 1
      }
      params.merge!({
        operatorid: operator_id
      })
      response = client.run_action :msisdn_info, params

      if(response.data[:open_range_minimum_amount_local_currency] != nil)
        return TransferToApi::MsisdnInfoOpenRange.new(response)
      elsif(response.data[:product_list] != nil)
        # fixed denomination
        return TransferToApi::MsisdnInfoFixedDenomination.new(response)
      else
        raise "Request failed. Status: #{response.status}. Parameters: #{params}"
      end
    end

    def initialize(response)
      super(response)
      @operator = TransferToApi::Operator.new(response.data[:country], response.data[:countryid], response.data[:operator], response.data[:operatorid])
      @connection_status = response.data[:connection_status]
      @destination_msisdn = response.data[:destination_msisdn]
      @destination_currency = response.data[:destination_currency]
      @open_range = response.data[:open_range]
    end

  end
end
