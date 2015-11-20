module TransferToApi
  class GetIdFromKey < Base

    attr_reader :transaction_id

    # get the transaction-id from an authentication key
    def self.get(key)
        params = { from_key: key }
        response = run_action :get_id_from_key, params
        TransferToApi::GetIdFromKey.new(response)
    end

    def initialize(response)
      super(response)
      @transaction_id = response.data[:id]
    end
  end
end

# list = TransferToApi::GetIdFromKey.login('rechargeops', 'uGyRrKfyTP').get('1448007022')

