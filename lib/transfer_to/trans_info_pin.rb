module TransferToApi
  class TransInfoPin < TransInfo

    attr_reader :pin_value, :pin_code, :pin_serial, :pin_ivr, :pin_validity,
    :pin_option_1, :pin_option_2, :pin_option_3

    def initialize(response)
      super(response)
      @pin_value = response.data[:pin_value]
      @pin_code = response.data[:pin_code]
      @pin_serial = response.data[:pin_serial]
      @pin_ivr = response.data[:pin_ivr]
      @pin_validity = response.data[:pin_validity]
      @pin_option_1 = response.data[:pin_option_1]
      @pin_option_2 = response.data[:pin_option_2]
      @pin_option_3 = response.data[:pin_option_3]
    end
  end
end