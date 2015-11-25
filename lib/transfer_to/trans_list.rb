module TransferToApi
  class TransList < Base

    attr_reader :transaction_ids

    # This method is used to retrieve the list of transactions performed within
    # the date range by the MSISDN if set. Note that both dates are included
    # during the search.
    #
    # parameters
    # ==========
    # start_date
    # ----------
    # Defines the start date of the search. Format must be YYYY-MM-DD.
    #
    # stop_date
    # ---------
    # Defines the end date of the search (included). Format must be YYYY-MM-DD.
    #
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
    def self.get(start_date, end_date, msisdn=nil, destination=nil, code=nil)
      params = { }

      params[:code] = code unless code
      params[:msisdn] = msisdn unless msisdn
      params[:stop_date] = end_date
      params[:start_date] = start_date
      params[:destination_msisdn] = destination unless destination

      response = run_action :trans_list, params
      TransferToApi::TransList.new(response)
    end


    def initialize(response)
      super(response)
      @transaction_ids = response.data[:transaction_list].split(',')
    end
  end
end
