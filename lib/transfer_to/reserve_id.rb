module TransferToApi
  class ReserveId < Base

    attr_reader :reserved_id

    def self.get
      response = run_action :reserve_id
      TransferToApi::ReserveId.new(response)
    end

    def initialize(response)
      super(response)
      @reserved_id = response.data[:reserve_id]
    end
  end
end

# test = TransferToApi::ReserveId.login('rechargeops', 'uGyRrKfyTP').get



