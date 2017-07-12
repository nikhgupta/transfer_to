module TransferToApi
  class ReserveId < Base

    attr_reader :reserved_id

    # This method is used to reserve an ID in the system. This ID can then be
    # used in the “topup” or “simulation” requests.
    # This way, your system knows the IDof the transaction before sending the
    # request to TransferTo (else it will only be displayed in the response).
    def self.get(*args)
      args.prepend(TransferToApi::Client.new)
      self.send(:get_from_client, *args)
    end

    def self.get_from_client(client)
      response = client.run_action :reserve_id
      TransferToApi::ReserveId.new(response)
    end

    def initialize(response)
      super(response)
      @reserved_id = response.data[:reserved_id]
    end
  end
end