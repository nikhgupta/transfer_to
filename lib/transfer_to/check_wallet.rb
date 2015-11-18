module TransferToApi
  class CheckWallet < Base

    attr_reader :type, :login, :currency, :balance, :wallet

    # This function is used to retrieve the credit balance in your TransferTo
    # account.
    def self.get
      response = run_action :check_wallet
      TransferToApi::CheckWallet.new(response)
    end

    def initialize(response)
      super(response)
      @type = response.data[:type]
      @login = response.data[:login]
      @currency = response.data[:currency]
      @balance = response.data[:balance]
      @wallet = response.data[:wallet]
    end
  end
end

# wallet = TransferToApi::CheckWallet.login('rechargeops', 'uGyRrKfyTP').get
# => {:type=>"Master", :login=>"rechargeops", :currency=>"USD", :balance=>"30.00", :wallet=>"30.00", :authentication_key=>"1447841914", :error_code=>0, :error_txt=>"Transaction successful"}



