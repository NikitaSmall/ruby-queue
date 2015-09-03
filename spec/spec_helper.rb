require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
require 'rspec'
require 'rack/test'

require 'active_record'
require 'database_cleaner'

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "db/test.db"
  ActiveRecord::Migrator.up(File.join(File.dirname(__FILE__), '../db/migrate'), ENV['VERSION'] ? ENV['VERSION'].to_i : nil )

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
