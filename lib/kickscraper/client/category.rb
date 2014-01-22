module Kickscraper
    class Category < Api
        attr_accessor :projects

        def to_s
            name
        end

        def inspect
            "<Category: '#{to_s}'>"
        end

        def projects
            return [] unless @projects || self.urls.web.discover
            @projects ||= Kickscraper.client.process_api_url("Projects", self.urls.web.discover)
        end
    end
end
