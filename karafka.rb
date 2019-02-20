# frozen_string_literal: true

# Non Ruby on Rails setup
ENV['RAILS_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] = ENV['RAILS_ENV']

require ::File.expand_path('../config/environment', __FILE__)
Rails.application.eager_load!

# This lines will make Karafka print to stdout like puma or unicorn
if Rails.env.development?
  Rails.logger.extend(
    ActiveSupport::Logger.broadcast(
      ActiveSupport::Logger.new($stdout)
    )
  )
end

# Ruby on Rails setup
# Remove whole non-Rails setup that is above and uncomment the 4 lines below
# ENV['RAILS_ENV'] ||= 'development'
# ENV['KARAFKA_ENV'] = ENV['RAILS_ENV']
# require ::File.expand_path('../config/environment', __FILE__)
# Rails.application.eager_load!

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
    config.client_id = 'kafka_demo_app'
    config.backend = :inline
    config.batch_fetching = true
    # Uncomment this for Rails app integration
    config.logger = Rails.logger
  end

  after_init do |config|
    # Put here all the things you want to do after the Karafka framework
    # initialization
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::Listener)
  consumer_groups.draw do
    # topic :example do
    #   consumer ExampleConsumer
    # end

    # consumer_group :bigger_group do
    #   topic :test do
    #     consumer TestConsumer
    #   end
    #
    #   topic :test2 do
    #     consumer Test2Consumer
    #   end
    # end

    consumer_group :test_group do
      topic :test do
        consumer UserConsumer
        start_from_beginning true
        batch_consuming false
      end
    end
  end
end
KarafkaApp.boot!

WaterDrop.setup do |waterdrop_config|
  waterdrop_config.logger = Rails.logger
end