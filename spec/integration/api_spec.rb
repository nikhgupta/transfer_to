require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Transfer To API Client' do
  before do
    @client = TransferTo::API.new('rechargecomusdor', 'oUZfUwxwfV')
  end

  it 'should send a ping and receive pong' do
    expect(@client.ping.data[:info_txt]).to eq 'pong'
  end

  it 'should send pricelist and receive a list of countries' do
    expect(@client.pricelist('countries').data[:error_code]).to eq 0
  end

  it 'should send msisdn_info with number and receive information about the carrier' do
    response = @client.msisdn_info(TransferTo::Base::TEST_NUMBERS[:one], 'USD')
    expect(response.data[:country]).to eq 'Indonesia'
  end

  it 'should send pricelist with country and receive a list of operators for that country' do
    r = @client.pricelist('country', 767)
    expect(r.data[:country]).to eq 'Indonesia'
  end

  it 'should simulate a topup and receive response' do
  end

end