require 'faraday'
require 'faraday_middleware'
require 'uri/query_params'

class KSToken < Faraday::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    env[:url].query_params['oauth_token'] = Kickscraper.token unless Kickscraper.token.nil?
    @app.call(env)
  end
end

module Kickscraper
  module Connection

    private

    def connection
      options = {
        :headers => {'Accept' => "application/json; charset=utf-8", 'User-Agent' => "Kickscraper/XXX"},
        :ssl => {:verify => false},
        :url => "https://api.kickstarter.com",
        :proxy => Kickscraper.proxy.nil? ? "" : Kickscraper.proxy
      }

      @connection ||= Faraday::Connection.new(options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify
        #connection.use FaradayMiddleware::Caching, {}
        connection.use Faraday::Response::ParseJson
        connection.use ::KSToken
        connection.adapter(Faraday.default_adapter)
      end
    end
  end
end
