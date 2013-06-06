module Kickscraper
	module Configure

		attr_accessor :email, :password, :token, :proxy

		def configure
      		yield self
    	end
	end

end