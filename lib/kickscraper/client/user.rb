module Kickscraper
    class User < Api
    	attr_accessor :backed_projects, :starred_projects

    	def to_s
    		name
    	end

        def reload!
            @raw = Kickscraper.client.process_api_url("User", self.urls.api.user, false)
            Kickscraper::User::do_coercion(self)
        end
        
        def biography
            reload! unless @raw['biography']
            @raw['biography']
        end

        def backed_projects
        	return [] unless self.urls.api.backed_projects
            @backed_projects ||= Kickscraper.client.process_api_url("Projects", self.urls.api.backed_projects)
        end

        def starred_projects
        	return [] unless self.urls.api.starred_projects
            @starred_projects ||= Kickscraper.client.process_api_url("Projects", self.urls.api.starred_projects)
        end
        
        def created_projects
            return [] unless self.urls.api.created_projects
            @created_projects ||= Kickscraper.client.process_api_url("Projects", self.urls.api.created_projects)
        end
    end
end