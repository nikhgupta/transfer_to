module TransferToApi
  class TopupPin < Topup

    attr_reader :pin_based, :pin_option_1, :pin_option_2, :pin_option_3,
      :pin_value, :pin_code, :pin_ivr, :pin_serial, :pin_validity

    def initialize(response)
      @pin_based = response.data[:pin_based]
      @pin_option_1 = response.data[:pin_option_1]
      @pin_option_2 = response.data[:pin_option_2]
      @pin_option_3 = response.data[:pin_option_3]
      @pin_value = response.data[:pin_value]
      @pin_code = response.data[:pin_code]
      @pin_ivr = response.data[:pin_ivr]
      @pin_serial = response.data[:pin_serial]
      @pin_validity = response.data[:pin_validity]
      super(response)
    end
  end
end



