module TransferToApi
  class ReserveId < Base

    attr_reader :reserved_id

    def get
      response = run_action :reserve_id
      response
    end

    protected

    def populate(response)
      super(response)
      @reserved_id = response.data[:reserve_id]
    end
  end
end

# test = TransferToApi::ReserveId.new('rechargeops', 'uGyRrKfyTP')



