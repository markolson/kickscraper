require_relative 'user.rb'
require_relative 'update.rb'

module Kickscraper
    class Project < Api
        coerce_key :creator, Kickscraper::User
        coerce_key :category, Kickscraper::Category

        attr_accessor :rewards, :updates, :comments, :full

        def to_s
            name
        end

        def inspect
            "<Project: '#{to_s}'>"
        end

        def reload!
            @raw = Kickscraper.client.raw.get(self.urls.api.project).body
        end

        def rewards
            reload! unless @rewards
            @rewards ||= raw['rewards']
        end

        def successful?
           pledged >= goal
        end

        def active?
            state == "live"
        end

        def comments
            return [] unless self.urls.api.comments
        end

        def updates
            reload! unless self.urls.api.updates
            @updates ||= Kickscraper.client.raw.get(URI.parse(self.urls.api.updates).path).body.updates.map {|o|
                Update.coerce(o)
            }
        end
    end
end