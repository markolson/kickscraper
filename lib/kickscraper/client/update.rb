module Kickscraper
    class Update < Api
        attr_accessor :sequence, :title, :body

        def reload!
            @raw = Kickscraper.client.process_api_url("Update", self.urls.api.update, false)
            Kickscraper::Update::do_coercion(self)
        end

        def sequence
            reload! unless @raw['sequence']
            @raw['sequence']
        end

        def title
            reload! unless @raw['title']
            @raw['title']
        end

        def body
            reload! unless @raw['body']
            @raw['body']
        end

    end
end