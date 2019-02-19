class UserResponder < ApplicationResponder
    topic :test
    def respond(user)
        respond_to :test, user.to_json
    end
end