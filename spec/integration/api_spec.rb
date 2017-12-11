require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Transfer To API Client' do

  before do
    # open range stuff are actual test numbers. We can topup this number safely.
    @open_range_country_id = '767'
    @open_range_operator_id = '1310'
    @open_range_country_name = 'Indonesia'
    @open_range_product_name = 'AAA-TESTING Indonesia'
    @open_range_phone_number = '628123456770'

    # this is not an official test number. Do not topup this number!
    @fixed_denomination_operator_id = '385'
    @fixed_denomination_country_id = '799'
    @fixed_denomination_operator_name = 'Maxis Malaysia'
    @fixed_denomination_phone_number = '60172860300'

    #this is an actual test number. We can topup this number safely.
    @pin_based_phone_number = "628123456710"

    # error numbers
    @error_204_phone_number = '628123456780'
    @error_301_phone_number = '628123456781'
    @error_214_phone_number = '628123456790'
    @error_998_phone_number = '628123456798'
    @error_999_phone_number = '628123456799'

    # real transactions that have been performed because they couldn't be
    # tested otherwise.
    @pin_based_transaction_id = '539070192'
    @pin_based_transaction_authentication_key = '14909596082727013589'
    @pinless_transaction_id = '539109977'
  end

  context '#pricelist' do
    it 'should return a list of countries' do
      VCR.use_cassette('countries') do
        pricelist = TransferToApi::Pricelist.get_countries
        expect(pricelist.error_code).to eq 0
        expect(pricelist.countries.length).to be > 10

        country = pricelist.countries.detect { |n| n.id == @open_range_country_id}
        expect(country.name).to eq @open_range_country_name
      end
    end

    it 'with country should return a list of operators for that country' do
      VCR.use_cassette('operators') do
        pricelist = TransferToApi::Pricelist.get_operators_for_country(@open_range_country_id)
        expect(pricelist.error_code).to eq 0
        expect(pricelist.operators.length).to be > 5

        operator = pricelist.operators.detect { |n| n.id == @open_range_operator_id}
        expect(operator.country.name).to eq @open_range_country_name
        expect(operator.name).to eq @open_range_product_name
      end
    end

    it 'with an open range operator should return a list of open range products' do
      VCR.use_cassette('open-range-products') do
        pricelist = TransferToApi::Pricelist.get_products_for_operator(@open_range_operator_id)
        expect(pricelist.error_code).to eq 0
        expect(pricelist.products.length).to eq 1

        product = pricelist.products.first
        expect(product.class).to eq TransferToApi::PricelistOpenRangeProduct
        expect(product.operator.country.id).to eq @open_range_country_id
        expect(product.open_range).to eq "1"
        expect(product.operator.name).to eq @open_range_product_name
      end
    end

    it 'with an fixed denomination operator should return a list of fixed denomination products' do
      VCR.use_cassette('fixed-denomination-products') do
        pricelist = TransferToApi::Pricelist.get_products_for_operator(@fixed_denomination_operator_id)
        expect(pricelist.error_code).to eq 0
        expect(pricelist.products.length).to be > 3

        product = pricelist.products.first
        expect(product.class).to eq TransferToApi::PricelistFixedProduct
        expect(product.operator.country.id).to eq @fixed_denomination_country_id
        expect(product.operator.name).to eq @fixed_denomination_operator_name
      end
    end

    it 'detects a wrongly marked open range product and treats it like a fixed denomination product' do
      wrong_open_range_response = OpenStruct.new(
        data: {
          product_list: '1,2',
          retail_price_list: '10,11',
          wholesale_price_list: '5,6',
          skuid_list: '123,456',
          open_range: '1'
        }
      )
      client = TransferToApi::Client.new('user', 'pass')
      allow(client).to receive(:run_action) { wrong_open_range_response }
      pricelist = TransferToApi::Pricelist.get_products_for_operator_from_client(client, 'operator1')
      expect(pricelist.products.size).to eq 2
      expect(pricelist.products.first.class).to eq TransferToApi::PricelistFixedProduct
      expect(pricelist.products.second.class).to eq TransferToApi::PricelistFixedProduct
    end
  end

  context '#msisdn_info' do
    it 'for an open range carrier should return open range information' do
      VCR.use_cassette('open-range-msisdn-info') do
        info = TransferToApi::MsisdnInfo.get(@open_range_phone_number)
        expect(info.error_code).to eq 0

        expect(info.operator.country.id).to eq @open_range_country_id
        expect(info.operator.id).to eq @open_range_operator_id
        expect(info.class).to eq TransferToApi::MsisdnInfoOpenRange
      end
    end

    it 'for an fixed denomination carrier should return fixed denomination information' do
      VCR.use_cassette('fixed-denomination-msisdn-info') do
        info = TransferToApi::MsisdnInfo.get(@fixed_denomination_phone_number)
        expect(info.error_code).to eq 0

        expect(info.operator.country.id).to eq @fixed_denomination_country_id
        expect(info.operator.id).to eq @fixed_denomination_operator_id
        expect(info.class).to eq TransferToApi::MsisdnInfoFixedDenomination
      end
    end
  end

  context '#reserve id' do
    it 'should receive a transaction id' do
      VCR.use_cassette('reserve-id') do
        reserve_id = TransferToApi::ReserveId.get
        expect(reserve_id.error_code).to eq 0
        expect(reserve_id.reserved_id).to match(/^[0-9]{8}[0-9]*$/)
      end
    end
  end

  context '#topup' do
    it 'on a pinless operator should perform a pinless topup' do
      info = nil
      VCR.use_cassette('open-range-msisdn-info') do
        info = TransferToApi::MsisdnInfo.get(@open_range_phone_number)
        expect(info.error_code).to eq 0
      end

      VCR.use_cassette('topup-open-range') do
        topup = TransferToApi::Topup.perform_action('Recharge.com', @open_range_phone_number, info.minimum_amount_requested_currency, info.skuid, info.requested_currency, nil, nil, nil, nil, true)
        expect(topup.error_code).to eq 0
        expect(topup.destination_msisdn).to eq @open_range_phone_number
        expect(topup.local_info_amount).to eq info.minimum_amount_local_currency
        expect(topup.skuid).to eq info.skuid
        expect(topup.open_range_requested_amount).to eq info.minimum_amount_requested_currency
        expect(topup.operator.country.id).to eq @open_range_country_id
        expect(topup.operator.id).to eq @open_range_operator_id
        expect(topup.class).to eq TransferToApi::Topup
        expect { topup.pin_based }.to raise_error(NoMethodError)
        expect { topup.pin_code }.to raise_error(NoMethodError)
      end
    end

    it 'on a pin based operator should perform a pin based topup' do
      info = nil
      VCR.use_cassette('pin-based-msisdn-info') do
        info = TransferToApi::MsisdnInfo.get(@pin_based_phone_number)
        expect(info.error_code).to eq 0
      end


      VCR.use_cassette('topup-pin-based') do
        topup = TransferToApi::Topup.perform_action('Recharge.com', @pin_based_phone_number, info.minimum_amount_requested_currency, info.skuid, info.requested_currency)
        expect(topup.error_code).to eq 0
        expect(topup.destination_msisdn).to eq @pin_based_phone_number
        expect(topup.local_info_amount).to eq info.minimum_amount_local_currency
        expect(topup.skuid).to eq info.skuid
        expect(topup.open_range_requested_amount).to eq info.minimum_amount_requested_currency
        expect(topup.operator.country.id).to eq @open_range_country_id
        expect(topup.operator.id).to eq @open_range_operator_id
        expect(topup.class).to eq TransferToApi::TopupPin
        expect(topup.pin_based).to eq 'yes'
        expect(topup.pin_code).to match(/^[0-9]{4}[0-9]*$/)
      end
    end

    it 'on a fixed denomination operator should successfully a topup' do
      info = nil
      VCR.use_cassette('fixed-denomination-msisdn-info') do
        info = TransferToApi::MsisdnInfo.get(@fixed_denomination_phone_number)
        expect(info.error_code).to eq 0
      end


      VCR.use_cassette('topup-fixed-denomination') do
        topup = TransferToApi::Topup.perform_action('Recharge.com', @fixed_denomination_phone_number, info.products.first.product, info.products.first.skuid, info.requested_currency, nil, nil, nil, nil, true)
        expect(topup.error_code).to eq 0
        expect(topup.destination_msisdn).to eq @fixed_denomination_phone_number
        expect(topup.local_info_amount).to eq info.products.first.local_amount
        expect(topup.skuid).to eq info.products.first.skuid
        expect(topup.open_range_requested_amount).to eq info.products.first.product
        expect(topup.operator.country.id).to eq info.operator.country.id
        expect(topup.operator.id).to eq info.operator.id
        expect(topup.class).to eq TransferToApi::Topup
        expect { topup.pin_based }.to raise_error(NoMethodError)
        expect { topup.pin_code }.to raise_error(NoMethodError)
      end
    end
  end

  context '#test topup errors should try a topup and throw error' do
    it 'no valid prepaid number' do
      test_error(@error_204_phone_number, TransferToApi::CommandException::NO_VALID_PREPAID_NR)
    end

    it 'denomination not available' do
      test_error(@error_301_phone_number, TransferToApi::CommandException::DENOMINATION_NOT_AVAILABLE)
    end

    it 'transaction refused' do
      test_error(@error_214_phone_number, TransferToApi::CommandException::TOPUP_REFUSED)
    end

    it 'system unavailable' do
      test_error(@error_998_phone_number, TransferToApi::CommandException::SYSTEM_NOT_AVAILABLE)

    end

    it 'unknown error' do
      test_error(@error_999_phone_number, TransferToApi::CommandException::UNKNOWN_ERROR)
    end

    def test_error(error_phone_number, expected_exception_code)
      VCR.use_cassette('error-msisdn-info' + error_phone_number) do
        expect {
          info = TransferToApi::MsisdnInfo.get(error_phone_number)
          expect(info.error_code).to eq 0
          topup = TransferToApi::Topup.perform_action('Recharge.com', error_phone_number, info.minimum_amount_requested_currency, info.skuid, info.requested_currency)
        }.to raise_exception(TransferToApi::CommandException){|ex| expect(ex.code).to eq expected_exception_code}
      end
    end
  end

  context '#trans_list' do
    it 'should return a list of transactions' do
      VCR.use_cassette('transactions') do
        list = TransferToApi::TransList.get('2016-11-01', '2016-11-10')
        expect(list.error_code).to eq 0
        expect(list.transaction_ids.count).to be > 3
      end
    end
  end

  context '#trans_info' do
    # we can only test trans_info for topups that have really been performed.
    # As a real topup costs money, we can not perform a topup every time the tests
    # run. Whe therefore use hardcoded previously executed topups.
    it 'should return information about a pinless transaction' do
      VCR.use_cassette('pinless-transaction') do
        info = TransferToApi::TransInfo.get(@pinless_transaction_id)
        expect(info.error_code).to eq 0
        expect(info.actual_product_sent).to eq '35'
        expect(info.pin_based).to eq 'no'
        expect(info.operator.id).to eq '1534'
        expect(info.class).to eq TransferToApi::TransInfo
      end
    end

    it 'should return information about a pin transaction' do
      VCR.use_cassette('pin-transaction') do
        info = TransferToApi::TransInfo.get(@pin_based_transaction_id)
        expect(info.error_code).to eq 0
        expect(info.actual_product_sent).to eq '100'
        expect(info.pin_based).to eq 'yes'
        expect(info.operator.id).to eq '2440'
        expect(info.class).to eq TransferToApi::TransInfoPin
        expect(info.pin_code).to eq '410128408676'
      end
    end

    # optional: tests with information about failed transactions.
    #"425369915", "425369954", "425369882", "425370005", "425370052", "425494271", "425494299", "425494333", "425494398", "425494360"]
  end

  context '#get_id_from_key' do
    # we can only get id from key of actual transactions. We therefore have to
    # test against previously done real transactions.
    it 'should return the transaction-id based from an authentication_key' do
      VCR.use_cassette('get-id-from-key') do
        id_from_key = TransferToApi::GetIdFromKey.get(@pin_based_transaction_authentication_key)
        expect(id_from_key.error_code).to eq 0
        expect(id_from_key.transaction_id).to eq @pin_based_transaction_id
      end
    end
  end

  context '#check_wallet' do
    it 'should get the credit in the transferto account' do
      VCR.use_cassette('check-wallet') do
        credit = TransferToApi::CheckWallet.get
      end
    end
  end

  context '#credentials' do
    it 'should use credentials from login function before looking for credentials in config' do
      # exception proves we use the wrong given username/password instead of the
      # correct user/pass in the configuration.
      VCR.use_cassette('wrong-credentials') do
        expect {
          client = TransferToApi::Client.new('wrongusername', 'wrongpassword')
          pricelist = TransferToApi::Pricelist.get_countries_from_client(client)
        }.to raise_exception(TransferToApi::CommandException)
      end
    end
  end
end
