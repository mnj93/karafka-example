class UserConsumer < ApplicationConsumer
    def consume
        puts "new message received at #{Time.now} : #{params["user"]}"
    end
end