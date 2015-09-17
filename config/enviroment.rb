require 'rubygems'
require 'active_record'
# require 'activerecord-jdbcpostgresql-adapter' if defined? JRUBY_VERSION
require 'yaml'

# require 'logger'

# load configs
dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), 'database.yml')))

# log to console
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), '../logs/logfile.log'))

# connect
ActiveRecord::Base.establish_connection(dbconfig)
