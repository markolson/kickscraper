module Kickscraper
	module Configure

		attr_accessor :email, :password, :token

		def configure
      		yield self
    	end
	end

end