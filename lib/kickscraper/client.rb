require 'uri'

module Kickscraper
    class Client
        include Connection
        
        attr_accessor :user
        
        def initialize
            if Kickscraper.token.nil?
                token_response = connection.post('xauth/access_token?client_id=2II5GGBZLOOZAA5XBU1U0Y44BU57Q58L8KOGM7H0E0YFHP3KTG', {'email' => Kickscraper.email, 'password' => Kickscraper.password }.to_json)
                if token_response.body.error_messages
                    raise token_response.body.error_messages.join("\n")
                    return
                end
                Kickscraper.token = token_response.body.access_token
                @user = User.coerce(token_response.body.user)
            end
        end

        def find_user(id)
            self::process_api_call "user", id.to_s
        end

        def find_project(id_or_slug)
            self::process_api_call "project", id_or_slug.to_s
        end

        def search_projects(q, page = nil)
            self::process_api_call "projects", "search", "q=" + URI.escape(q), page
        end

        def ending_soon_projects(deadline_timestamp = nil)
            self::process_api_call "projects", "ending_soon", "", deadline_timestamp
        end

        def popular_projects(page = nil)
            self::process_api_call "projects", "popular", "", page
        end

        def recently_launched_projects(starting_at_timestamp = nil)
            self::process_api_call "projects", "recently_launched", "", starting_at_timestamp
        end

        alias_method :newest_projects, :recently_launched_projects
        
        def can_load_more_projects
            !@more_projects_url.nil?
        end
        
        alias_method :more_projects_available?, :can_load_more_projects

        def load_more_projects
            if self::can_load_more_projects
                self::process_api_url "projects", @more_projects_url
            else
                []
            end
        end

        def categories
            self::process_api_call "categories", ""
        end

        def category(id_or_name = nil)
            return categories.find{|i| i.name.downcase.start_with? id_or_name.downcase} if id_or_name.is_a? String
                self::process_api_call "category", id_or_name.to_s
        end


        def process_api_call(request_for, additional_path, query_string = "", cursor = nil)
            
            # create the path to the API resource we want
            api_path = self::create_api_path(request_for, additional_path, query_string, cursor)
            
            
            # make the api call
            response = connection.get(api_path)
            
            
            # handle the response, returning an object with the results
            self::coerce_api_response(request_for, response)
        end
        
        
        def process_api_url(request_for, api_url, coerce_response = true)
            
            # make the api call to whatever url we specified
            response = connection.get(api_url)
            
            
            # if we want to coerce the response, do it now
            if coerce_response
                
                self::coerce_api_response(request_for, response)
                
            # else, just return the raw body
            else
                
                response.body
            end
        end
        
        
        def coerce_api_response(expected_type, response)
            
            # define what we should return as an empty response, based on the expected type
            types_that_should_return_an_array = ["projects", "comments", "updates", "categories"]
            empty_response = (types_that_should_return_an_array.include? expected_type) ? [] : nil
            
            
            # get the body from the response
            body = response.body

            
            # if we got an error response back, stop here and return an empty response
            return empty_response if response.headers['status'].to_i >= 400 || !response.headers['content-type'].start_with?('application/json')
            return empty_response if !body.error_messages.nil? || body.http_code == 404
            
            
            # otherwise, take the response from the api and coerce it to the type we want
            case expected_type.downcase
            when "user"
                
                User.coerce body
                
            when "project"
                
                Project.coerce body
                
            when "projects"
                
                # if the body doesn't have any projects, return an empty array
                if body.projects.nil?
                    
                    @more_projects_url = nil
                    return empty_response
                    
                    
                # else, set the url for where we can load the next batch of projects (if it
                # exists) and then return an array of projects
                else
                    
                    @more_projects_url = (!body.urls.nil? && !body.urls.api.nil? && !body.urls.api.more_projects.nil? && !body.urls.api.more_projects.empty?) ? body.urls.api.more_projects : nil
                    return body.projects.map { |project| Project.coerce project }
                end
                
            when "comments"
                
                return empty_response if body.comments.nil?
                body.comments.map { |comment| Comment.coerce comment }
                
            when "updates"
                
                return empty_response if body.updates.nil?
                body.updates.map { |update| Update.coerce update }
                
            when "categories"
                return empty_response if body.categories.nil?
                body.categories.map { |category| Category.coerce category }
            
            when "category"
                Category.coerce body

            else    
                raise ArgumentError, "invalid api request type"
            end
        end
        
        
        def create_api_path(request_for, additional_path, query_string = "", cursor = nil)
            
            # start with the base path
            base_path = "/v1"
            full_uri = base_path
            
            
            # set a specific sub path for users and projects
            case request_for.downcase
            when "user"
                full_uri += "/users"
            when "project", "projects"
                full_uri += "/projects"
            when "category", "categories"
                full_uri += "/categories"
            end
            
            
            # add the additional path if we have it
            full_uri += "/" + URI.escape(additional_path) unless additional_path.empty?
            
            
            # add the cursor to the query string if we have it
            cursor = cursor.to_i
            if cursor > 0 then query_string = query_string.empty? ? "cursor=#{cursor}" : "#{query_string}&cursor=#{cursor}" end
            
            
            # add the query string if we have it
            full_uri += "?" + query_string unless query_string.empty?
            
            
            # return the final uri
            full_uri
        end
    end
end