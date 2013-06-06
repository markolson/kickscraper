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
            self::do_coercion(a)
            a
        end
        
        def self.do_coercion(instance)
            self.key_coercions.each{ |k,v| instance.raw[k] = v.coerce(instance.raw[k]) }
        end
        
        def uid
            self.id == Kickscraper.client.user.id ? 'self' : self.id
        end

    end
end

Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| load f}