require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
require 'rspec'
require 'rack/test'

require 'active_record'
require 'database_cleaner'
require 'factory_girl'
require 'webmock/rspec'

PORT = 6019
logger = Logger.new('logs/logfile.log')

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "db/test.db"
  ActiveRecord::Migrator.up(File.join(File.dirname(__FILE__), '../db/migrate'), ENV['VERSION'] ? ENV['VERSION'].to_i : nil )

  config.include FactoryGirl::Syntax::Methods
  WebMock.disable_net_connect!

  config.before(:suite) do
    FactoryGirl.reload
    FactoryGirl.lint
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:suite) do
    @thr = Thread.new do
      logger.debug { "starting new thread to serve the connections" }
      @broker = Broker.instance
      @broker.start_serve(PORT)
    end

    @thr.run
  end

  config.after(:suite) do
    logger.debug { "closing new thread" }
    @thr.kill
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      logger.debug { "run the example: it #{example.description}" }
      example.run
    end
  end
end
