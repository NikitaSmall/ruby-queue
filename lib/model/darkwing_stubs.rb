require 'active_record'
require 'platform-api'

class Rails
  def self.root
    ROOT_DIR
  end

  def self.env
    ENV
  end

  def self.logger
    @logger ||= Logger.new STDERR
  end
end

Excon.defaults[:ssl_verify_peer] = false
=begin
def connection_string
  return ENV['DATABASE_URL'] if ENV['DATABASE_URL']

  heroku = PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])
  heroku.config_var.info(ENV['TARGET_HEROKU_APP'])['DATABASE_URL']
end

ActiveRecord::Base.establish_connection connection_string
=end
class User < ActiveRecord::Base; end

class HadoopError < ActiveRecord::Base; end
class HadoopReducerError < HadoopError; end

class Customer < ActiveRecord::Base; end
class SemCampaign < ActiveRecord::Base; end
class AdGroup < ActiveRecord::Base; end
class Ad < ActiveRecord::Base; end
class Keyword < ActiveRecord::Base; end

class AdwordsCustomer < Customer; end
class AdwordsSemCampaign < SemCampaign; end
class AdwordsAdGroup < AdGroup; end
class AdwordsAd < Ad
  has_many :adwords_ad_stats, dependent: :delete_all, primary_key: :external_id
end
class AdwordsKeyword < Keyword; end

class AdwordsSemCampaignStat < ActiveRecord::Base; end
class AdwordsAdGroupStat < ActiveRecord::Base; end
class AdwordsAdGroupStatDevice < ActiveRecord::Base; end
class AdwordsAdGroupStatClick < ActiveRecord::Base; end
class AdwordsAdGroupStatNetwork < ActiveRecord::Base; end
class AdwordsAdStat < ActiveRecord::Base; end
class AdwordsKeywordStat < ActiveRecord::Base; end

class BingCustomer < Customer; end
class BingSemCampaign < SemCampaign; end
class BingAdGroup < AdGroup; end
class BingAd < Ad; end
class BingKeyword < Keyword; end

class BingSemCampaignStat < ActiveRecord::Base; end
class BingAdGroupStat < ActiveRecord::Base; end
class BingAdStat < ActiveRecord::Base; end
class BingKeywordStat < ActiveRecord::Base; end

class MobileReport < ActiveRecord::Base; end
class TrafficChannelsReport < ActiveRecord::Base; end
class TopContentReport < ActiveRecord::Base; end
class TopReferringReport < ActiveRecord::Base; end
class TrafficMetricsReport < ActiveRecord::Base; end
class LocationReport < ActiveRecord::Base; end
class Website < ActiveRecord::Base
  enum industry: %w'UNSPECIFIED
ARTS_AND_ENTERTAINMENT
AUTOMOTIVE
BEAUTY_AND_FITNESS
BOOKS_AND_LITERATURE
BUSINESS_AND_INDUSTRIAL_MARKETS
COMPUTERS_AND_ELECTRONICS
FINANCE
FOOD_AND_DRINK
GAMES
HEALTHCARE
HOBBIES_AND_LEISURE
HOME_AND_GARDEN
INTERNET_AND_TELECOM
JOBS_AND_EDUCATION
LAW_AND_GOVERNMENT
NEWS
ONLINE_COMMUNITIES
OTHER
PEOPLE_AND_SOCIETY
PETS_AND_ANIMALS
REAL_ESTATE
REFERENCE
SCIENCE
SHOPPING
SPORTS
TRAVEL'
end
class UsersWebsite < ActiveRecord::Base; end
class GaRegion < ActiveRecord::Base; end
class GaCity < ActiveRecord::Base; end
class GaUsersReport < ActiveRecord::Base; end
class ContentPage < ActiveRecord::Base; end
class GaReferrer < ActiveRecord::Base; end

class Order < ActiveRecord::Base
  enum status: [:draft, :pending_approval, :approved, :dissaproved, :paused, :canceled, :deleted, :unknown]
end

class DisplayCampaign < ActiveRecord::Base
  belongs_to :order

  has_and_belongs_to_many :creatives
  has_many :display_campaign_targets, foreign_key: :display_campaign_dfp_id, primary_key: :external_id
  has_many :targets, source: :target, through: :display_campaign_targets
  has_many :ad_unit_display_campaigns, foreign_key: :display_campaign_dfp_id, primary_key: :external_id
  has_many :ad_units, source: :ad_unit, through: :ad_unit_display_campaigns
end

class AdUnit < ActiveRecord::Base
  enum status: [:active, :inactive, :archived]
end
class AdUnitDisplayCampaign < ActiveRecord::Base
  belongs_to :ad_unit, foreign_key: :ad_unit_dfp_id, primary_key: :dfp_id
end

class Creative < ActiveRecord::Base
  has_and_belongs_to_many :display_campaigns
end
class CreativesDisplayCampaign < ActiveRecord::Base; end

class Target < ActiveRecord::Base; end
class DisplayCampaignTarget < ActiveRecord::Base
  belongs_to :target, foreign_key: :target_dfp_id, primary_key: :dfp_id
end

class DfpCreative < Creative; end
class DfpDisplayCampaign < DisplayCampaign; end
class DfpCreativeSet < ActiveRecord::Base; end

class DfpCreativeStat < ActiveRecord::Base; end
class DfpDisplayCampaignStat < ActiveRecord::Base; end
class CreativesDisplayCampaignStat < ActiveRecord::Base; end
