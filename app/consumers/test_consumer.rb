class TestConsumer < ApplicationConsumer
    def consume
        puts "new message arrived : #{params}"
    end
end