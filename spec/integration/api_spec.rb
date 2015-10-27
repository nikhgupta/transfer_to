require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Transfer To API Client' do
  before do
    begin
      lines = File.readlines(File.expand_path(File.dirname(__FILE__) + '/../credentials.txt'))
      acc = lines[0].chomp
      pwd = lines[1].chomp
      @client = TransferTo::API.new(acc, pwd)
    rescue => e
      puts "#{e} Could not read credentials"
      raise
    end
  end

  # region Metric Tests
  it 'should send a ping and receive pong' do
    expect(@client.ping.data[:info_txt]).to eq 'pong'
  end
  # end region

  # region Account Tests
  it 'should send pricelist and receive a list of countries' do
    expect(@client.pricelist('countries').data[:error_code]).to eq 0
  end

  it 'should send pricelist with country and receive a list of operators for that country' do
    r = @client.pricelist('country', 767)
    expect(r.data[:country]).to eq 'Indonesia'
  end

  it 'should send pricelist with operator and receive a list of products for that operator' do
    r = @client.pricelist('country', 767)
    operators = r.data[:operatorid]
    ops = operators.split(',')

    puts ""
    puts "starting pricelist"
    ops.each do |op_code|
      puts " Operator #{op_code}"
      r = @client.pricelist('operator', op_code)
      puts " Products: #{r.data[:product_list]}"
    end
    operator_id = 1411
    r = @client.pricelist('operator', 1411)
    expect_succesfull_response r
  end
  # end region

  # region Basics Tests
  it 'should send msisdn_info with number and receive information about the carrier' do
    response = @client.msisdn_info(TransferTo::Base::TEST_NUMBERS[:one], 'USD')

    expect_succesfull_response response
    expect(response.data[:country]).to eq 'Indonesia'
  end

  it 'should send msisdn_info with number and receive information about the carrier' do
    response = @client.msisdn_info(TransferTo::Base::TEST_NUMBERS[:one], 'USD')

    expect_succesfull_response response
    expect(response.data[:country]).to eq 'Indonesia'
  end

  it 'should send a reservation and receive a transaction id' do
    response = @client.reserve_id

    expect_succesfull_response response
    expect(response.data[:reserved_id]).not_to eq nil
  end

  it 'should simulate a topup and receive response' do
    response = create_topup_simulation true

    expect_succesfull_response response
  end

  it 'should simulate a topup and respond to PIN based Operators' do
    response = create_topup_simulation true, TransferTo::Base::TEST_NUMBERS[:one], TransferTo::Base::TEST_NUMBERS[:one]

    puts " -> #{response.data[:error_txt]}"
    expect_succesfull_response response
    #expect(response.data[:pin_based]).to eq "Yes"
    #expect(response.data[:pin_validity]).not_to eq nil
    #expect(response.data[:pin_code]).not_to eq nil
    #expect(response.data[:pin_ivr]).not_to eq nil
    #expect(response.data[:pin_serial]).not_to eq nil
    #expect(response.data[:pin_value]).not_to eq nil
  end

  it 'should simulate a topup and respond to PIN less Operators' do
    response = create_topup_simulation true, TransferTo::Base::TEST_NUMBERS[:two], TransferTo::Base::TEST_NUMBERS[:two]

    expect_succesfull_response response
    expect(response.data[:authentication_key]).not_to eq nil
  end

  it 'should simulate a topup and throw a destination number is not a prepaid phone number error' do
    expect {
      create_topup_simulation false, TransferTo::Base::TEST_NUMBERS[:three], TransferTo::Base::TEST_NUMBERS[:three]
    }.to raise_exception(TransferTo::Error){|ex| expect(ex.code).to eq 204}
  end

  # This number is temporarily unavailable for testing ..
  it 'should simulate a topup and throw an invalid product error' do
    expect {
        create_topup_simulation false, TransferTo::Base::TEST_NUMBERS[:four], TransferTo::Base::TEST_NUMBERS[:four]
    }.to raise_exception(TransferTo::Error){|ex| expect(ex.code).to eq 301}
  end

  it 'should simulate a topup and throw a transaction refused error' do
      expect {
        create_topup_simulation false, TransferTo::Base::TEST_NUMBERS[:five], TransferTo::Base::TEST_NUMBERS[:five]
      }.to raise_exception(TransferTo::Error){|ex| expect(ex.code).to eq 214 }
  end

  it 'should simulate a topup and throw a system unavailable error' do
    expect {
      create_topup_simulation false, TransferTo::Base::TEST_NUMBERS[:six], TransferTo::Base::TEST_NUMBERS[:six]
    }.to raise_exception(TransferTo::Error) {|ex| expect(ex.code).to eq 998 }
  end

  it 'should simulate a topup and throw an unknown error' do
    expect {
      create_topup_simulation false, TransferTo::Base::TEST_NUMBERS[:seven], TransferTo::Base::TEST_NUMBERS[:seven]
    }.to raise_exception(TransferTo::Error) {|ex| expect(ex.code).to eq 999 }
  end
  # end region

  # region Reports Tests
  it 'should return the list of transactions performed during a given date range' do
    response = @client.trans_list Date.today.prev_day.to_s, Date.today.to_s

    puts " -> #{response.data[:error_txt]}"
    expect_succesfull_response response
  end

  it 'should return all available information on a specific transaction id' do
    simulate = false
    msisdn = TransferTo::Base::TEST_NUMBERS[:one]
    destination = TransferTo::Base::TEST_NUMBERS[:one]
    product = 3
    currency = 'USD'
    operator_id = 1310
    recipient_sms = nil
    sender_sms = nil

    # Retrieves information about the MSISDN
    info_response = @client.msisdn_info(msisdn, currency, operator_id)
    expect_succesfull_response info_response

    sku_id = info_response.data[:skuid]
    operatorid = info_response.data[:operatorid]
    puts " product: #{product}"
    puts " SKU ID: #{sku_id}"
    puts " Operator ID: #{operatorid}"

    # Creates a reservation id
    reservation_response = create_reservation
    expect_succesfull_response reservation_response

    reserved_id = reservation_response.data[:reserved_id]

    # Uses the reservation id to simulate a topup
    r = @client.topup(msisdn, destination, product, sku_id, currency, reserved_id,
                  recipient_sms, sender_sms, operator_id, simulate)
    expect_succesfull_response r

    response = @client.trans_info reservation_response.data[:reserved_id]
    expect_succesfull_response response

    puts " -> #{response.data[:error_txt]}"
  end
  # end region


  # Test helpers
  def create_reservation()
    response = @client.reserve_id

    expect_succesfull_response response
    expect(response.data[:reserved_id]).not_to eq nil
    return response
  end

  def create_topup_simulation(
    simulate,
    msisdn = TransferTo::Base::TEST_NUMBERS[:one],
    destination = TransferTo::Base::TEST_NUMBERS[:one],
    product = 3,
    currency = 'USD',
    operator_id = 1310,
    recipient_sms = nil,
    sender_sms = nil)

    puts ""
    puts "starting simulation .."

    # Retrieves information about the MSISDN
    info_response = @client.msisdn_info(msisdn, currency, operator_id)
    expect_succesfull_response info_response
    sku_id = info_response.data[:skuid]
    operatorid = info_response.data[:operatorid]

    puts " product: #{product}"
    puts " SKU ID: #{sku_id}"
    puts " Operator ID: #{operatorid}"

    # Creates a reservation id
    reservation_response = create_reservation
    expect_succesfull_response reservation_response
    reserved_id = reservation_response.data[:reserved_id]

    puts " Transaction ID: #{reserved_id}"

    # Uses the reservation id to simulate a topup
    r = @client.topup(msisdn, destination, product, sku_id, currency, reserved_id,
                  recipient_sms, sender_sms, operator_id, simulate)
  end

  def expect_succesfull_response(response)
    expect(response.data).not_to eq nil
    expect(response.data[:error_code]).to eq 0
    expect(response.data[:error_txt]).to eq "Transaction successful"
  end
end
