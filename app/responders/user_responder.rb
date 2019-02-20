class UserResponder < ApplicationResponder
    topic :test
    def respond(user)
        data = {"user" => user}
        respond_to :test, data.to_json
    end
end