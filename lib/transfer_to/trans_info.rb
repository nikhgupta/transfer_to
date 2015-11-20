module TransferToApi
  class TransInfo < Base

    attr_reader :transactionid, :msisdn, :destination_msisdn,
    :transaction_authentication_key, :transaction_error_code,
    :transaction_error_txt, :country, :countryid, :operator, :operatorid,
    :reference_operator, :product_requested, :actual_product_sent,
    :wholesale_price, :retail_price, :sms, :cid1, :cid2, :cid3, :date,
    :originating_currency, :destination_currency, :pin_based, :local_info_amount,
    :local_info_currency,:local_info_value,
    :open_range, :open_range_local_amount_delivered, :open_range_local_amount_requested,
    :open_range_local_currency, :open_range_requested_amount, :open_range_requested_currency,
    :open_range_wholesale_cost, :open_range_wholesale_currency,
    :open_range_wholesale_discount, :open_range_wholesale_rate

    def self.get(transaction_id)
      params = {transactionid: transaction_id}
      response = run_action :trans_info, params
      return response
      TransferToApi::TransInfo.new(response)
    end

    def initialize(response)
      super(response)
      @transactionid = response.data[:transactionid]
      @msisdn = response.data[:msisdn]
      @destination_msisdn = response.data[:destination_msisdn]
      @transaction_authentication_key = response.data[:transaction_authentication_key]
      @transaction_error_code = response.data[:transaction_error_code]
      @transaction_error_txt = response.data[:transaction_error_txt]
      @country = response.data[:country]
      @countryid = response.data[:countryid]
      @operator = response.data[:operator]
      @operatorid = response.data[:operatorid]
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

#60172860300
# info = TransferToApi::MsisdnInfo.login('rechargeops', 'uGyRrKfyTP').get('60172860300')
# topup = TransferToApi::Topup.login('rechargeops', 'uGyRrKfyTP').perform('Recharge.com', '60172860300', '1.62', '7499', 'USD')

# test = TransferToApi::TransInfo.login('rechargeops', 'uGyRrKfyTP').get('428661615')   # open range transaction
#  :transactionid=>"428661615",
#  :msisdn=>"Recharge.com",
#  :destination_msisdn=>"923026282547",
#  :transaction_authentication_key=>"1447943007",
#  :transaction_error_code=>"0",
#  :transaction_error_txt=>"Transaction successful",
#  :country=>"Pakistan",
#  :countryid=>"832",
#  :operator=>"Mobilink Pakistan",
#  :operatorid=>"400",
#  :reference_operator=>"R228224622",
#  :product_requested=>"50.22",
#  :actual_product_sent=>"50.22",
#  :wholesale_price=>"0.51",
#  :retail_price=>"0.56",
#  :sms=>nil,
#  :cid1=>nil,
#  :cid2=>nil,
#  :cid3=>nil,
#  :date=>"2015-11-19 14:23:29",
#  :originating_currency=>"USD",
#  :destination_currency=>"PKR",
#  :pin_based=>"no",
#  :local_info_amount=>"37.66",
#  :local_info_currency=>"PKR",
#  :local_info_value=>"50.22",
#  :open_range=>"1",
#  :open_range_local_amount_delivered=>"0.00",
#  :open_range_local_amount_requested=>"0",
#  :open_range_local_currency=>"PKR",
#  :open_range_requested_amount=>"0.56",
#  :open_range_requested_currency=>"USD",
#  :open_range_wholesale_cost=>"0",
#  :open_range_wholesale_currency=>"USD",
#  :open_range_wholesale_discount=>"9.00",
#  :open_range_wholesale_rate=>"98.47",
#  :authentication_key=>"1447944082",
#  :error_code=>0,
#  :error_txt=>"Transaction successful"


# test = TransferToApi::TransInfo.login('rechargeops', 'uGyRrKfyTP').get('428796615')   # pin transaction

# [2] pry(#<RSpec::ExampleGroups::TransferToAPIClient>)> test.data
# => {:transactionid=>"428796615",
#  :msisdn=>"Recharge.com",
#  :destination_msisdn=>"60172860300",
#  :transaction_authentication_key=>"1448007022",
#  :transaction_error_code=>"0",
#  :transaction_error_txt=>"Transaction successful",
#  :country=>"Malaysia",
#  :countryid=>"799",
#  :operator=>"Maxis Malaysia",
#  :operatorid=>"385",
#  :reference_operator=>nil,
#  :product_requested=>"5",
#  :actual_product_sent=>"5",
#  :wholesale_price=>"1.46",
#  :retail_price=>"1.62",
#  :sms=>nil,
#  :cid1=>nil,
#  :cid2=>nil,
#  :cid3=>nil,
#  :date=>"2015-11-20 08:10:25",
#  :originating_currency=>"USD",
#  :destination_currency=>"MYR",
#  :pin_based=>"no",
#  :local_info_amount=>"5.0",
#  :local_info_currency=>"MYR",
#  :local_info_value=>"5.0",
#  :open_range=>"1",
#  :open_range_local_amount_delivered=>"0.00",
#  :open_range_local_amount_requested=>"0",
#  :open_range_local_currency=>"MYR",
#  :open_range_requested_amount=>"1.62",
#  :open_range_requested_currency=>"USD",
#  :open_range_wholesale_cost=>"0",
#  :open_range_wholesale_currency=>"USD",
#  :open_range_wholesale_discount=>"10.00",
#  :open_range_wholesale_rate=>"3.42",
#  :authentication_key=>"1448008039",
#  :error_code=>0,
#  :error_txt=>"Transaction successful"}





# [3] pry(#<RSpec::ExampleGroups::TransferToAPIClient>)> topup = TransferToApi::Topup.login('rechargeops', 'uGyRrKfyTP').perform('Recharge.com', '60172860300', '1.62', '7499', 'USD')
# => #<TransferToApi::Topup:0x007fa259887ea0
#  @authentication_key="1448007022",
#  @balance="28.03",
#  @cid1=nil,
#  @cid2=nil,
#  @cid3=nil,
#  @country_id="799",
#  @country_name="Malaysia",
#  @destination_currency="MYR",
#  @destination_msisdn="60172860300",
#  @error_code=0,
#  @error_txt="Transaction successful",
#  @info_txt=nil,
#  @local_info_amount="5.0",
#  @local_info_currency="MYR",
#  @local_info_value="5.0",
#  @msisdn="Recharge.com",
#  @open_range="1",
#  @open_range_local_amount_delivered="5.00",
#  @open_range_local_amount_requested="5.00",
#  @open_range_local_currency="MYR",
#  @open_range_requested_amount="1.62",
#  @open_range_requested_currency="USD",
#  @open_range_wholesale_cost="1.46",
#  @open_range_wholesale_currency="USD",
#  @open_range_wholesale_discount="10.00",
#  @open_range_wholesale_rate="3.42",
#  @operator_id="385",
#  @operator_name="Maxis Malaysia",
#  @originating_currency="USD",
#  @reference_operator=nil,
#  @retail_price="1.62",
#  @return_timestamp="2015-11-20 08:10:25",
#  @return_version="2.34f",
#  @service_fee="0",
#  @skuid="7499",
#  @sms=nil,
#  @sms_sent="yes",
#  @transaction_id="428796615",
#  @wholesale_price="1.46">

