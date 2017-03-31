module TransferToApi
  class TransInfo < Base

    attr_reader :transactionid, :msisdn, :destination_msisdn, :operator,
    :transaction_authentication_key, :transaction_error_code,
    :transaction_error_txt,:reference_operator, :product_requested,
    :actual_product_sent, :wholesale_price, :retail_price, :sms, :cid1, :cid2,
    :cid3, :date, :originating_currency, :destination_currency, :pin_based,
    :local_info_amount, :local_info_currency,:local_info_value,
    :open_range, :open_range_local_amount_delivered, :open_range_local_amount_requested,
    :open_range_local_currency, :open_range_requested_amount, :open_range_requested_currency,
    :open_range_wholesale_cost, :open_range_wholesale_currency,
    :open_range_wholesale_discount, :open_range_wholesale_rate

    # This method can be used to retrieve available information on a specific
    # transaction. Please note that values of "input_value" and
    # "debit_amount_validated" are rounded to 2 digits after the comma but are
    # the same as the values returned in the fields "input_value" and
    # "validated_input_value" of the "topup" method response.
    def self.get(*args)
      args.prepend(TransferToApi::Client.new)
      self.send(:get_from_client, *args)
    end

    def self.get_from_client(client, transaction_id)
      params = {transactionid: transaction_id}
      response = client.run_action :trans_info, params
      if response.data[:pin_based] == 'yes'
        return TransferToApi::TransInfoPin.new(response)
      else
        return TransferToApi::TransInfo.new(response)
      end
    end

    def initialize(response)
      super(response)

      @operator = TransferToApi::Operator.new(response.data[:country], response.data[:countryid], response.data[:operator], response.data[:operatorid])

      @transactionid = response.data[:transactionid]
      @msisdn = response.data[:msisdn]
      @destination_msisdn = response.data[:destination_msisdn]
      @transaction_authentication_key = response.data[:transaction_authentication_key]
      @transaction_error_code = response.data[:transaction_error_code]
      @transaction_error_txt = response.data[:transaction_error_txt]
      @transactionid = response.data[:transactionid]
      @reference_operator = response.data[:reference_operator]
      @product_requested = response.data[:product_requested]
      @actual_product_sent = response.data[:actual_product_sent]
      @wholesale_price = response.data[:wholesale_price]
      @retail_price = response.data[:retail_price]
      @sms = response.data[:sms]
      @cid1 = response.data[:cid1]
      @cid2 = response.data[:cid2]
      @cid3 = response.data[:cid3]
      @date = response.data[:date]
      @originating_currency = response.data[:originating_currency]
      @destination_currency = response.data[:destination_currency]
      @pin_based = response.data[:pin_based]
      @local_info_amount = response.data[:local_info_amount]
      @local_info_currency = response.data[:local_info_currency]
      @local_info_value = response.data[:local_info_value]

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
    end
  end
end