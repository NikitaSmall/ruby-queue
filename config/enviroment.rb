require 'rubygems'
require 'active_record'
require 'yaml'

# load configs
dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), 'database.yml')))

# log to console
ActiveRecord::Base.logger = Logger.new(STDERR)

# connect
ActiveRecord::Base.establish_connection(dbconfig)
