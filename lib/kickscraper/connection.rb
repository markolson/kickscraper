require 'faraday'
require 'faraday_middleware'
require 'uri/query_params'

class KSToken < Faraday::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    # replace '+' symbols in the query params with their original spaces, because there
    # seems to be a bug in the way some versions of Fararay escape parameters with spaces
    env[:url].query_params.each { |key, value|
      env[:url].query_params[key] = value.tr('+', ' ')
    }
    
    # add format=json to all public search requests, or add the oauth_token to all api requests once we have it
    if env[:url].to_s.index('https://api.kickstarter.com').nil?
      env[:url].query_params['format'] = 'json'
    else
      env[:url].query_params['oauth_token'] = Kickscraper.token unless Kickscraper.token.nil?
    end
    
    # make the call
    @app.call(env)
  end
end

module Kickscraper
  module Connection

    private

    def connection(api_or_search = "api")
      options = {
        :headers => {'Content-Type' => 'application/json', 'Accept' => "application/json; charset=utf-8", 'User-Agent' => "Kickscraper/XXX"},
        :ssl => {:verify => false},
        :url => api_or_search == "api" ? "https://api.kickstarter.com" : "https://www.kickstarter.com",
        :proxy => Kickscraper.proxy.nil? ? "" : Kickscraper.proxy
      }
      
      if api_or_search == "api"
        @api_connection ||= Faraday::Connection.new(options) do |connection|
          connection.use Faraday::Request::UrlEncoded
          connection.use FaradayMiddleware::Mashify
          connection.use FaradayMiddleware::FollowRedirects
          connection.use Faraday::Response::ParseJson
          connection.use ::KSToken
          connection.adapter(Faraday.default_adapter)
        end
      else
        @search_connection ||= Faraday::Connection.new(options) do |connection|
          connection.use Faraday::Request::UrlEncoded
          connection.use FaradayMiddleware::Mashify
          connection.use FaradayMiddleware::FollowRedirects
          connection.use Faraday::Response::ParseJson
          connection.use ::KSToken
          connection.adapter(Faraday.default_adapter)
        end
      end
    end
  end
end
