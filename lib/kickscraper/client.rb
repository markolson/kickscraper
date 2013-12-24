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

        def search_projects(query, page = nil)
            self::process_api_call "projects", "search", query, page
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
        
        def more_projects_available?
            !@more_projects_url.nil?
        end
        
        alias_method :can_load_more_projects, :more_projects_available?

        def load_more_projects
            if self::more_projects_available?
                self::process_api_url "projects", @more_projects_url
            else
                []
            end
        end

        def more_updates_available?
            !@more_updates_url.nil?
        end

        alias_method :can_load_more_updates, :more_updates_available?

        def load_more_updates
            if self::more_updates_available?
                self::process_api_url "updates", @more_updates_url
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


        def process_api_call(request_for, additional_path, query = "", cursor = nil)
            
            # create the path to the API resource we want
            url_and_params = self::create_api_path(request_for, additional_path, query, cursor)
            
            
            # make the api call
            response = connection.get(url_and_params[:url], url_and_params[:params])
            
            
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
            return empty_response if (body.respond_to?("error_messages") && !body.error_messages.empty?) || (body.respond_to?("http_code") && body.http_code == 404)
            
            
            # otherwise, take the response from the api and coerce it to the type we want
            case expected_type.downcase
            when "user"
                
                User.coerce body
                
            when "project"
                
                Project.coerce body
                
            when "projects"
                
                # if the body is just an array of projects, with no root keys, then coerce
                # the array
                if body.is_a?(Array)
                    
                    body.map { |project| Project.coerce project }
                    
                    
                # else, if the body doesn't have any projects, return an empty array
                elsif body.projects.nil?
                    
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

            when "update"

                Update.coerce body
                
            when "updates"
                
                # Return an empty result set if the body has no updates
                if body.updates.nil?

                    @more_updates_url = nil
                    return empty_response

                # Otherwise, set the url that holds the next batch of updates (if available)
                # and return an array of updates
                else

                    @more_updates_url = (!body.urls.nil? && !body.urls.api.nil? && !body.urls.api.more_updates.nil? && !body.urls.api.more_updates.empty?) ? body.urls.api.more_updates : nil
                    return body.updates.map { |update| Update.coerce update }
                end
                
            when "categories"
                
                return empty_response if body.categories.nil?
                body.categories.map { |category| Category.coerce category }
            
            when "category"
                
                Category.coerce body

            else    
                raise ArgumentError, "invalid api request type"
            end
        end
        
        
        def create_api_path(request_for, additional_path = "", query_string = "", cursor = nil)
            
            # start with the base path
            base_path = "/v1"
            url = base_path
            
            
            # set a specific sub path for users and projects
            case request_for.downcase
            when "user"
                url += "/users"
            when "project", "projects"
                url += "/projects"
            when "category", "categories"
                url += "/categories"
            end
            
            
            # add the additional path if we have it
            url += "/" + CGI.escape(additional_path) unless additional_path.empty?
            
            
            # create the params hash and add the params we want
            params = {}
            params[:q] = query_string unless query_string.empty?
            params[:cursor] = cursor unless cursor.nil?
            
            
            # return the url and params
            {url: url, params: params}
        end
    end
end