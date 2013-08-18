module TransferTo
  class API < Base

    # This method can be used when you want to test the connection and your
    # account credentials.
    def ping
      run_action :ping
    end

    # This function is used to retrieve the credit balance in your TransferTo
    # account.
    def check_wallet
      run_action :check_wallet
    end

    # This method is used to recharge a destination number with a specified
    # denomination (“product” field).
    # This is the API’s most important action as it is required when sending
    # a topup to a prepaid account phone numberin a live! environment.
    #
    # parameters
    # ==========
    # msisdn
    # ------
    # The international phone number of the user requesting to credit
    # a TransferToAPI phone number. The format must contain the country code,
    # and will be valid with or without the ‘+’ or ‘00’ placed before it. For
    # example: “6012345678” or “+6012345678” or “006012345678” (Malaysia) are
    # all valid.
    #
    # product
    # -------
    # This field is used to define the remote product(often, the same as the
    # amount in destination currency) to use in the request.
    #
    # destination
    # -----------
    # This is the destination phone number that will be credited with the
    # amount transferred. Format is similar to “msisdn”.
    #
    # operator_id
    # -----------
    # It defines the operator id of the destination MSISDN that must be used
    # when treating the request. If set, the platform will be forced to use
    # this operatorID and will not identify the operator of the destination
    # MSISDN based on the numbering plan. It must be very useful in case of
    # countries with number portability if you are able to know the destination
    # operator.

    def topup(msisdn, destination, product, reserved_id = nil,
              recipient_sms = nil, sender_sms = nil, operator_id = nil)
      @params     = { msisdn: msisdn, destination_msisdn: destination, product: product }
      self.oid    = operator_id

      @params.merge({
        cid1: "", cid2: "", cid3: "",
        reserved_id: reserved_id,
        sender_sms: (sender_sms ? "yes" : "no"),
        sms: recipient_sms,
        sender_text: sender_sms,
        delivered_amount_info: "1",
        return_service_fee: "1",
        return_timestamp: "1",
        return_version: "1"
      })

      run_action :topup
    end

    # This method is used to retrieve various information of a specific MSISDN
    # (operator, country…) as well as the list of all products configured for
    # your specific account and the destination operator of the MSISDN.
    def msisdn_info(msisdn, operator_id=nil)
      @params = {
        destination_msisdn: msisdn,
        delivered_amount_info: "1",
        return_service_fee: 1
      }
      self.oid = operator_id
      run_action :msisdn_info
    end

    # This method can be used to retrieve available information on a specific
    # transaction. Please note that values of “input_value” and
    # “debit_amount_validated” are rounded to 2 digits after the comma but are
    # the same as the values returned in the fields “input_value” and
    # “validated_input_value” of the “topup” method response.
    def trans_info(id)
      @params = { transactionid: id }
      run_action :trans_info
    end

    # This method is used to retrieve the list of transactions performed within
    # the date range by the MSISDN if set. Note that both dates are included
    # during the search.
    #
    # parameters
    # ==========
    # msisdn
    # ------
    # The format must be international with or without the ‘+’ or ‘00’:
    # “6012345678” or “+6012345678” or “006012345678” (Malaysia)
    #
    # destination_msisdn
    # ------------------
    # The format must be international with or without the ‘+’ or ‘00’:
    # “6012345678” or “+6012345678” or “006012345678” (Malaysia)
    #
    # code
    # ----
    # The error_code of the transactions to search for. E.g “0” to search for
    # only all successful transactions. If left empty, all transactions will be
    # returned(Failed and successful).
    #
    # start_date
    # ----------
    # Defines the start date of the search. Format must be YYYY-MM-DD.
    #
    # stop_date
    # ---------
    # Defines the end date of the search (included). Format must be YYYY-MM-DD.

    def trans_list(start, stop, msisdn = nil, destination = nil, code = nil)
      @params[:code]               = code unless code
      @params[:msisdn]             = msisdn unless msisdn
      @params[:stop_date]          = to_yyyymmdd(stop)
      @params[:start_date]         = to_yyyymmdd(start)
      @params[:destination_msisdn] = destination unless destination
      run_action :trans_list
    end

    # This method is used to reserve an ID in the system. This ID can then be
    # used in the “topup” or “simulation” requests.
    # This way, your system knows the IDof the transaction before sending the
    # request to TransferTo (else it will only be displayed in the response).
    def reserve_id
      run_action :reserve_id
    end

    # This method is used to retrieve the ID of a transaction previously
    # performed based on the key used in the request at that time.
    def get_id_from_key(key)
      @params = { from_key: key }
      run_action :get_id_from_key
    end

    # This method is used to retrieve coverage and pricelist offered to you.
    # parameters
    # ==========
    # info_type
    # ---------
    #   i) “countries”: Returns a list of all countries offered to you
    #  ii) “country”  : Returns a list of operators in the country
    # iii) “operator” : Returns a list of wholesale and retail price for the operator
    #
    # content
    # -------
    #   i) Not used if info_type = “countries”
    #  ii) countryid of the requested country if info_type = “country”
    # iii) operatorid of the requested operator if info_type = “operator”

    def pricelist(info_type, content = nil)
      @params[:info_type] = info_type
      @params[:content] = content unless content
      run_action :pricelist
    end

    private

    def oid=(operator_id)
      @params[:operatorid] = operator_id.to_i if operator_id.is_a?(Integer)
    end

  end
end
