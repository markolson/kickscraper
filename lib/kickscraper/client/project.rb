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
            @raw = Kickscraper.client.process_api_url("Project", self.urls.api.project, false)
            Kickscraper::Project::do_coercion(self)
        end

        def successful?
            pledged >= goal
        end

        def active?
            state == "live"
        end

        def comments
            return [] unless @comments || self.urls.api.comments
            @comments ||= Kickscraper.client.process_api_url("Comments", self.urls.api.comments)
        end

        def updates
            reload! unless @updates || self.urls.api.updates
            @updates ||= Kickscraper.client.process_api_url("Updates", self.urls.api.updates)
        end
        
        def rewards
            reload! unless @raw['rewards']
            @raw['rewards']
        end
    end
end