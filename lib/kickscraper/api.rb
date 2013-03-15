module Kickscraper
    class Api
        extend Connection
        include Hashie::Extensions::Coercion
        attr_accessor :raw

        def initialize(blob)
            @raw = blob
        end

        def method_missing(name)
            @raw.send(name) if @raw.respond_to? name
        end

        def self.coerce(raw)
            a = self.new(raw)
            self.key_coercions.each{|k,v|
                a.raw[k] = v.coerce(a.raw[k])
            }
            a
        end
        
        def uid
            self.id == Kickscraper.client.user.id ? 'self' : self.id
        end

    end
end

Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| load f}