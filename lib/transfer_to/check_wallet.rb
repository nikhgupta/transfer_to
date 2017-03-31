module TransferToApi
  class CheckWallet < Base

    attr_reader :type, :login, :currency, :balance, :wallet

    # This function is used to retrieve the credit balance in your TransferTo
    # account.
    def self.get(*args)
      args.prepend(TransferToApi::Client.new)
      self.send(:get_from_client, *args)
    end

    def self.get_from_client(client)
      response = client.run_action :check_wallet
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