require 'dotenv'
Dotenv.load('../.env')
APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../'))

=begin
require_relative './dfp/dfp'
require_relative './dfp/batch_fetcher'
require_relative './dfp/creatives_mapper'
require_relative './dfp/creative_sets_mapper'
require_relative './dfp/campaigns_mapper'
require_relative './dfp/campaigns_stats_mapper'
require_relative './dfp/creative_campaigns_mapper'
require_relative './dfp/stats_mapper'
require_relative './dfp/order_details_mapper'
require_relative './dfp/ad_units_mapper'
require_relative './dfp/targets_mapper'

require_relative './bing/connection_helper'
require_relative './bing/accounts_mapper'
require_relative './bing/campaigns_mapper'
require_relative './bing/ad_groups_mapper'
require_relative './bing/ads_mapper'
require_relative './bing/keywords_mapper'

require_relative './adwords/campaigns_mapper'
require_relative './adwords/campaigns_stats_mapper'

require_relative './adwords/ad_groups_mapper'
require_relative './adwords/ad_groups_stats_mapper'

require_relative './adwords/ads_mapper'
require_relative './adwords/ads_stats_mapper'

require_relative './adwords/keywords_mapper'
require_relative './adwords/keywords_stats_mapper'
=end

# require 'active_record'
require 'json'
require 'platform-api'

=begin
def connection_string
  return ENV['DATABASE_URL'] if ENV['DATABASE_URL']

  heroku = PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])
  heroku.config_var.info(ENV['TARGET_HEROKU_APP'])['DATABASE_URL']
end

ActiveRecord::Base.establish_connection connection_string
=end

class HadoopError < ActiveRecord::Base; end
class HadoopMapperError < HadoopError; end
class DarkwingUser < ActiveRecord::Base
  self.table_name = 'users'
end
class SemManager < ActiveRecord::Base; end
class Customer < ActiveRecord::Base; end
class AdwordsCustomer < Customer
  belongs_to :sem_manager
end

class MapManager
  REDUCER_KEY_DELIMITER = '#_#_'

  include Singleton

  def handle_exception(e, mapper_name = 'Unknown mapper', args = [])
    backtrace = e.backtrace[0..4].join "\n"
    message = e.message
    input = args.unshift(mapper_name).to_csv
    STDERR.puts "Input: #{input}"
    STDERR.puts "Error: #{message}"
    STDERR.puts backtrace
    HadoopMapperError.create(input: input, error_type: mapper_name, message: message, backtrace: e.backtrace.join("\n"))
  end

  def process_result(key, *args)
    # HOTFIX Only GA mappers generate correct keys
    # all other mappers use reducer type as key and in result of this all data handled by one reducer
    # We generate random reduce keys any mappers except analytics to spread input between reducers
    unless key.starts_with? 'analytics'
      key = [key, rand(100)].join(REDUCER_KEY_DELIMITER)
    end
    # MapReduce use tabulation as key/value separator, so, we need to escape it
    out = "#{key.gsub("\t", "\\t")}\t"
    out << args.to_csv.strip if args.any?
    out << "\n"

    log(out)

    output out
  end

  private

  def log(out)
    STDERR.puts "Output: #{out}"
  end

  def output(out)
    $stdout << out
  end
end
