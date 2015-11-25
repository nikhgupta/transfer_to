module TransferToApi
  class Topup < Base

    attr_reader :operator, :transaction_id, :msisdn, :destination_msisdn,
    :reference_operator, :originating_currency, :destination_currency,
    :wholesale_price, :retail_price, :service_fee, :balance,
    :sms_sent, :sms,:cid1, :cid2, :cid3, :reference_operator, :info_txt, :open_range,
    :open_range_local_amount_delivered, :open_range_local_amount_requested,
    :open_range_local_currency, :open_range_requested_amount,
    :open_range_requested_currency, :open_range_wholesale_cost,
    :open_range_wholesale_currency, :open_range_wholesale_discount,
    :open_range_wholesale_rate, :skuid, :local_info_value, :local_info_amount,
    :local_info_currency, :return_timestamp, :return_version


      # This method is used to recharge a destination number with a specified
      # denomination (“product” field).
      # This is the API’s most important action as it is required when sending
      # a topup to a prepaid account phone number in a live! environment.
      #
      # parameters
      # ==========
      # sender
      # ------
      # The international phone number or name of the user requesting to credit
      # a phone number (sender phone number). The format must contain the country
      # code, and will be valid with or without the ‘+’ or ‘00’ placed before it.
      # For example: “6012345678” or “+6012345678” or “006012345678” (Malaysia)
      # or “John” are all valid. This field must not be empty.
      #
      # destination
      # -----------
      # This is the destination phone number that will be credited with the
      # amount transferred. Format is similar to “msisdn”.The format must contain
      # the country code, and will be valid with or without the ‘+’ or ‘00’
      # placed before it. For example: “6012345678” or “+6012345678” or
      # “006012345678” (Malaysia) are all valid.
      #
      # amount
      # -------
      # This field is used to define the remote product to use in the request.
      # This is the amount to topup, requested in the account currency.
      #
      # operator_id
      # -----------
      # It defines the operator id of the destination MSISDN that must be used
      # when treating the request. If set, the platform will be forced to use
      # this operatorID and will not identify the operator of the destination
      # MSISDN based on the numbering plan. It must be very useful in case of
      # countries with number portability if you are able to know the destination
      # operator.
      #
      # simulate
      # ----------
      # Default: false
      # Sends the topup request without doing the actual topup.
      def self.perform(sender, destination, amount, skuid, currency = 'USD', reserved_id = nil,
                recipient_sms = nil, sender_sms = nil, operator_id = nil, simulate = false)
        params = { skuid: skuid, msisdn: sender, destination_msisdn: destination, product: amount }

        params.merge!({
          cid1: "", cid2: "", cid3: "",
          reserved_id: reserved_id,
          currency: currency,
          operatorid: (operator_id.is_a?(Integer) ? operator_id.to_i : nil),
          sender_sms: (sender_sms ? "yes" : "no"),
          sms: recipient_sms,
          skuid: skuid,
          sender_text: sender_sms,
          delivered_amount_info: "1",
          return_service_fee: "1",
          return_timestamp: "1",
          return_version: "1"
        })

        action = simulate ? :simulation : :topup
        response = run_action action, params
        if(response.data[:pin_based] == 'yes')
          return TransferToApi::TopupPin.new(response)
        else
          return TransferToApi::Topup.new(response)
        end

        response
      end

    def initialize(response)
      super(response)

      @operator = TransferToApi::Operator.new(response.data[:country], response.data[:countryid], response.data[:operator], response.data[:operatorid])

      @transaction_id = response.data[:transactionid]
      @msisdn = response.data[:msisdn]
      @destination_msisdn = response.data[:destination_msisdn]
      @reference_operator = response.data[:reference_operator]
      @originating_currency = response.data[:originating_currency]
      @destination_currency = response.data[:destination_currency]
      @wholesale_price = response.data[:wholesale_price]
      @retail_price = response.data[:retail_price]
      @service_fee = response.data[:service_fee]
      @balance = response.data[:balance]
      @sms_sent = response.data[:sms_sent]
      @sms = response.data[:sms]
      @cid1 = response.data[:cid1]
      @cid2 = response.data[:cid2]
      @cid3 = response.data[:cid3]
      @info_txt = response.data[:info_txt]
      @open_range = response.data[:open_range]
      @open_range_local_amount_delivered = response.data[:open_range_local_amount_delivered]
      @open_range_local_amount_requested = response.data[:open_range_local_amount_requested]
      @open_range_local_currency = response.data[:open_range_local_currency]
      @open_range_requested_amount = response.data[:open_range_requested_amount]
      @open_range_requested_currency = response.data[:open_range_requested_currency]
      @open_range_wholesale_cost = response.data[:open_range_wholesale_cost]
      @open_range_wholesale_currency = response.data[:open_range_wholesale_currency]
      @open_range_wholesale_discount = response.data[:open_range_wholesale_discount]
      @open_range_wholesale_rate = response.data[:open_range_wholesale_rate]
      @skuid = response.data[:skuid]
      @local_info_value = response.data[:local_info_value]
      @local_info_amount = response.data[:local_info_amount]
      @local_info_currency = response.data[:local_info_currency]
      @return_timestamp = response.data[:return_timestamp]
      @return_version = response.data[:return_version]
    end

  end
end