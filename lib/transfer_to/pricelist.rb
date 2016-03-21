module TransferToApi
  class Pricelist < Base

    attr_reader :countries, :operators, :products
    attr_writer :countries, :operators, :products

    # This method is used to retrieve coverage and pricelist offered to you.
    # parameters
    # ==========
    # info_type
    # ---------
    #   i) "countries": Returns a list of all countries offered to you
    #  ii) "country"  : Returns a list of operators in the country
    # iii) "operator" : Returns a list of wholesale and retail price for the operator
    #
    # content
    # -------
    #   i) Not used if info_type = "countries"
    #  ii) countryid of the requested country if info_type = "country"
    # iii) operatorid of the requested operator if info_type = "operator"
    # def pricelist(info_type, content = nil)
    #   params = {info_type: info_type}
    #   params.merge!({content: content}) if content
    #   run_action :pricelist, params
    # end

    def self.get_countries
      params = {info_type: 'countries'}
      response = run_action :pricelist, params

      pricelist = TransferToApi::Pricelist.new(response)

      country_name_list = response.data[:country].split(',')
      country_id_list = response.data[:countryid].split(',')

      countries = []
      country_name_list.count.times do |count|
        countries << TransferToApi::Country.new(country_name_list[count], country_id_list[count])
      end

      pricelist.countries = countries
      pricelist
    end

    def self.get_operators_for_country(country_id)
      params = {info_type: 'country', content: country_id}
      response = run_action :pricelist, params

      pricelist = TransferToApi::Pricelist.new(response)

      operator_name_list = response.data[:operator].split(',')
      operator_id_list = response.data[:operatorid].split(',')

      operators = []
      operator_name_list.count.times do |count|
        operators << TransferToApi::Operator.new(response.data[:country], response.data[:countryid], operator_name_list[count], operator_id_list[count])
      end

      pricelist.operators = operators
      pricelist
    end

    def self.get_products_for_operator(operator_id)
      params = {
        info_type: 'operator',
        content: operator_id,
        return_open_range_wholesale: '1',
        return_product_type: '1'
      }
      response = run_action :pricelist, params

      pricelist = TransferToApi::Pricelist.new(response)

      products = []
      if(response.data[:open_range] == '1')
        products << PricelistOpenRangeProduct.new(response)
      elsif(response.data[:product_list] != nil)
        product_list = response.data[:product_list].split(',')
        retail_price_list = response.data[:retail_price_list].split(',')
        wholesale_price_list = response.data[:wholesale_price_list].split(',')
        product_list.count.times do |count|
          products << TransferToApi::PricelistFixedProduct.new(
              product_list[count],
              retail_price_list[count],
              wholesale_price_list[count],
              response
          )
        end
      end

      pricelist.products = products
      pricelist
    end

    def initialize(response)
      super(response)
    end
  end
end