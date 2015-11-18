module TransferToApi
  class MsisdnInfo < Base

    attr_reader :country_name, :country_id, :operator_name, :operator_id,
      :connection_status, :destination_msisdn, :destination_currency, :open_range

    def self.get(phone_number, currency = 'USD', operator_id=nil)
      params = {
        destination_msisdn: phone_number,
        currency: currency,
        delivered_amount_info: "1",
        return_service_fee: 1
      }
      params.merge!({
        operatorid: (operator_id.is_a?(Integer) ? operator_id.to_i : nil)
      })
      response = run_action :msisdn_info, params

      if(response.data[:open_range_minimum_amount_local_currency] != nil)
        return TransferToApi::MsisdnInfoOpenRange.new(response)
      elsif(response.data[:product_list] != nil)
        # fixed denomination
        return TransferToApi::MsisdnInfoFixedDenomination.new(response)
      else
        raise "Unknown response type."
      end
    end

    def initialize(response)
      super(response)
      @country_name = response.data[:country]
      @country_id = response.data[:countryid]
      @operator_name = response.data[:operator]
      @operator_id = response.data[:operatorid]
      @connection_status = response.data[:connection_status]
      @destination_msisdn = response.data[:destination_msisdn]
      @destination_currency = response.data[:destination_currency]
      @open_range = response.data[:open_range]
    end

  end
end

# info = TransferToApi::MsisdnInfo.login('rechargeops', 'uGyRrKfyTP').get('628123456770')
# info = TransferToApi::MsisdnInfo.login('rechargeops', 'uGyRrKfyTP').get('923026282547') # open range
# info = TransferToApi::MsisdnInfo.login('rechargeops', 'uGyRrKfyTP').get('60172860300') # fixed denomination


# OPEN RANGE
# :country=>"Pakistan",
#  :countryid=>"832",
#  :operator=>"Mobilink Pakistan",
#  :operatorid=>"400",
#  :connection_status=>"99",
#  :destination_msisdn=>"923026282547",
#  :destination_currency=>"PKR",
#  :open_range=>"1",
#  :open_range_minimum_amount_local_currency=>"50",
#  :open_range_maximum_amount_local_currency=>"5000",
#  :open_range_minimum_amount_requested_currency=>"0.56",
#  :open_range_maximum_amount_requested_currency=>"55.79",
#  :open_range_increment_local_currency=>"0.01",
#  :open_range_requested_currency=>"USD",
#  :skuid=>"9934",
#  :authentication_key=>"1447750848",
#  :error_code=>0,
#  :error_txt=>"Transaction successful"}

# FIXED denomination
#  :country=>"Malaysia",
#  :countryid=>"799",
#  :operator=>"Maxis Malaysia",
#  :operatorid=>"385",
#  :connection_status=>"99",
#  :destination_msisdn=>"60172860300",
#  :destination_currency=>"MYR",
#  :open_range=>"1",                                                      << TOT AAN HIER IS MSISDN_INFO SPECIFIEK
#  :requested_currency=>"USD",                                            << VANAF HIER FIXED DENOMINATION SPECIFIEK
#  :product_list=>"1.58,3.16,6.33,9.49,18.99,31.65",
#  :retail_price_list=>"1.58,3.16,6.33,9.49,18.99,31.65",
#  :wholesale_price_list=>"1.42,2.84,5.70,8.54,17.09,28.48",
#  :service_fee_list=>"0.00,0.00,0.00,0.00,0.00,0.00",
#  :skuid_list=>"7499,1701,7500,1703,7501,1732",
#  :local_info_value_list=>"5.0,10.0,20.0,30.0,60.0,100.0",
#  :local_info_amount_list=>"5.0,10.0,20.0,30.0,60.0,100.0",
#  :local_info_currency=>"MYR",
#  :authentication_key=>"1447753328",                                     << VANAF HIER IS VOOR ELKE REQUEST
#  :error_code=>0,
#  :error_txt=>"Transaction successful"}




