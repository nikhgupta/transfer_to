module TransferToApi
  class GetIdFromKey < Base

    attr_reader :transaction_id

    # get the transaction-id from an authentication key
    def self.get(*args)
      args.prepend(TransferToApi::Client.new)
      self.send(:get_from_client, *args)
    end

    def self.get_from_client(client, key)
        params = { from_key: key }
        response = client.run_action :get_id_from_key, params
        TransferToApi::GetIdFromKey.new(response)
    end

    def initialize(response)
      super(response)
      @transaction_id = response.data[:id]
    end
  end
end
