require 'hashie'
require 'json'

require "kickscraper/version"
require "kickscraper/configure"
require "kickscraper/response"
require "kickscraper/connection"
require "kickscraper/client"
require "kickscraper/api"


module Kickscraper
  extend Configure
  attr_accessor :client

  def self.client
    @client ||= Kickscraper::Client.new
  end
end