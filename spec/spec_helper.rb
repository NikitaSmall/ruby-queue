require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
require 'rspec'
require 'rack/test'

require 'active_record'
require 'database_cleaner'
require 'factory_girl'

PORT = 7019
logger = Logger.new('logs/logfile.log')

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection adapter: "postgresql", database: "queue_test", username: "root", password: "toor", host: 'localhost'
  ActiveRecord::Migrator.up(File.join(File.dirname(__FILE__), '../db/migrate'), ENV['VERSION'] ? ENV['VERSION'].to_i : nil )

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.reload
    FactoryGirl.lint
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:suite) do
    @thr = Thread.new do
      logger.debug { "starting new thread to serve the connections" }

      @broker = Broker.instance
      @broker.start_serve(PORT)
    end

    @thr.run
    # @thr.join
  end

  config.after(:suite) do
    logger.debug { "closing new thread" }
    Thread.kill(@thr)
  end

  config.around(:each) do |example|

    DatabaseCleaner.cleaning do
      logger.debug { "run the example: it #{example.description}" }
      example.run
    end
  end
end
