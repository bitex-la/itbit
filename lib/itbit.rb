require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'rest_client'
require 'bigdecimal'
require 'digest/sha2'
require 'base64'
Dir[File.expand_path("../itbit/*.rb", __FILE__)].each {|f| require f}

module Itbit
  mattr_accessor :client_key
  mattr_accessor :secret
  mattr_accessor :user_id
  mattr_accessor :default_wallet_id
  mattr_accessor :sandbox
end
