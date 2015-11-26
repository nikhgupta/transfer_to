require "faraday"
require "net/http"
require 'ostruct'

module TransferToApi
  # Config class for rails projects
  class Config
    attr_accessor :username,
                  :password
  end

  def self.config
    @@config ||= Config.new
  end

  def self.configure
    yield self.config
  end
end


# require transfer_to files..
require "transfer_to/version"
require "transfer_to/command_exception"
require "transfer_to/request"
require "transfer_to/reply"
require "transfer_to/base"
require "transfer_to/msisdn_info"
require "transfer_to/msisdn_info_open_range"
require "transfer_to/msisdn_info_fixed_denomination"
require "transfer_to/msisdn_fixed_product"
require "transfer_to/pricelist_product"
require "transfer_to/pricelist_open_range_product"
require "transfer_to/pricelist_fixed_product"
require "transfer_to/trans_info"
require "transfer_to/trans_info_pin"
require "transfer_to/reserve_id"
require "transfer_to/topup"
require "transfer_to/topup_pin"
require "transfer_to/check_wallet"
require "transfer_to/pricelist"
require "transfer_to/country"
require "transfer_to/operator"
require "transfer_to/trans_list"
require "transfer_to/get_id_from_key"
require "transfer_to/connection_exception"
require "transfer_to/credentials_exception"