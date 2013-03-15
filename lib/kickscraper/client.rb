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
            User.coerce(connection.get("/v1/users/#{id}").body)
        end

        def find_project(id)
            Project.coerce(connection.get("/v1/projects/#{id}").body)
        end

        def search_projects(q)
            connection.get("/v1/projects/search?q=#{q}").body.projects.map { |project|
                Project.coerce(project)
            }
        end

        def raw
            connection
        end

    end
end