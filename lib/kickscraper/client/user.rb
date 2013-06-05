module Kickscraper
    class User < Api
    	attr_accessor :backed_projects, :starred_projects

    	def to_s
    		name
    	end

        def reload!
            @raw = Kickscraper.client.process_raw_api_url(self.urls.api.user)
        end

        def backed_projects
        	return [] unless self.urls.api.backed_projects
            @backed_projects ||= Kickscraper.client.coerce_projects(Kickscraper.client.process_raw_api_url(self.urls.api.backed_projects))
        end

        def starred_projects
        	return [] unless self.urls.api.starred_projects
            @starred_projects ||= Kickscraper.client.coerce_projects(Kickscraper.client.process_raw_api_url(self.urls.api.starred_projects))
        end
    end
end