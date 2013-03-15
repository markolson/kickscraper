module Kickscraper
  class Response

  	attr_accessor :body

    def initialize(res)
      @body = res.body
      return res.body
    end

    def error?
    	return false
    end
  end
end