require 'active_support/core_ext'
require 'json'
require 'rest_client'
require 'bigdecimal'
require 'active_support'
require 'digest/sha2'
require 'base64'
require 'itbit/match'
Dir[File.expand_path("../itbit/*.rb", __FILE__)].each {|f| require f}

module Itbit
  mattr_accessor :client_key
  mattr_accessor :secret
  mattr_accessor :user_id
  mattr_accessor :sandbox
end
