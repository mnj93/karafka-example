class UserController < ApplicationController
    protect_from_forgery
    def create
        UserResponder.call(user_params)
        render json: {"message" => "New user added","user" => user_params}
    end

    private
    def user_params
        params.require(:user).permit(:full_name, :email, :phone_number)
    end
end
