module Kickscraper
    class User < Api
    	attr_accessor :backed_projects, :created_projects

    	def to_s
    		name
    	end

        def reload!
            @raw = Kickscraper.client.raw.get(self.urls.api.user).body
        end

        def backed_projects
        	return [] unless self.urls.api.backed_projects
            @backed_projects ||= Kickscraper.client.raw.get(URI.parse(self.urls.api.backed_projects).path).body.projects.map {|project|
            	Project.coerce(project)
            }
        end

        def starred_projects
        	return [] unless self.urls.api.starred_projects
            @starred_projects ||= Kickscraper.client.raw.get(URI.parse(self.urls.api.starred_projects).path).body.projects.map {|project|
            	Project.coerce(project)
            }
        end
    end
end