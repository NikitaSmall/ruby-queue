require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
require 'rspec'
require 'rack/test'

require 'active_record'

RSpec.configure do |config|
  # reset database before each example is run
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
  ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), '../db/migrate'), ENV['VERSION'] ? ENV['VERSION'].to_i : nil )

  config.before(:each) do
  end
end
