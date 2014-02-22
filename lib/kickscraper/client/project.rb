require_relative 'user.rb'
require_relative 'category.rb'

module Kickscraper
    class Project < Api
        coerce_key :creator, Kickscraper::User
        coerce_key :category, Kickscraper::Category

        attr_accessor :comments, :updates, :rewards

        def to_s
            name
        end

        def inspect
            "<Project: '#{to_s}'>"
        end

        def reload!
            if self.urls.api.nil?
              the_full_project = Kickscraper.client.find_project(self.id)
              project_api_url = the_full_project.nil? ? nil : the_full_project.urls.api.project
            else
              project_api_url = self.urls.api.project
            end
            @raw = Kickscraper.client.process_api_url("Project", project_api_url, false) unless project_api_url.nil?
            Kickscraper::Project::do_coercion(self)
        end

        def successful?
            pledged >= goal
        end

        def active?
            state == "live"
        end

        def comments
            return @comments if @comments

            # must reload to get urls.api, not returned in public discover search
            reload! unless (self.urls.api && self.urls.api.comments)

            # if logged in and can use private API, self.urls.api.updates should now be defined
            if (self.urls.api && self.urls.api.updates)
              @comments = Kickscraper.client.process_api_url("Comments", self.urls.api.comments)
            else
              @comments= []
            end
        end

        def updates
            return @updates if @updates

            # must reload to get urls.api, not returned in public discover search
            reload! unless (self.urls.api && self.urls.api.updates)

            # if logged in and can use private API, self.urls.api.updates should now be defined
            if (self.urls.api && self.urls.api.updates)
              @updates = Kickscraper.client.process_api_url("Updates", self.urls.api.updates)
            else
              @updates = []
            end
        end
        
        def rewards
            reload! unless @raw['rewards']
            @raw['rewards']
        end
    end
end
