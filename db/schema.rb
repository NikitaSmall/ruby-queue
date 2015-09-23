# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150819154157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ad_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "sem_campaign_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "external_id",     limit: 8
    t.string   "status"
    t.string   "type"
  end

  add_index "ad_groups", ["external_id", "type"], name: "index_ad_groups_on_external_id_and_type", unique: true, using: :btree
  add_index "ad_groups", ["external_id"], name: "index_ad_groups_on_external_id", using: :btree
  add_index "ad_groups", ["sem_campaign_id", "external_id"], name: "index_ad_groups_on_sem_campaign_id_and_external_id", using: :btree
  add_index "ad_groups", ["sem_campaign_id"], name: "index_ad_groups_on_sem_campaign_id", using: :btree

  create_table "ad_unit_display_campaigns", force: :cascade do |t|
    t.integer  "ad_unit_dfp_id",          limit: 8, null: false
    t.integer  "display_campaign_dfp_id", limit: 8, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_unit_display_campaigns", ["ad_unit_dfp_id"], name: "index_ad_unit_display_campaigns_on_ad_unit_dfp_id", using: :btree
  add_index "ad_unit_display_campaigns", ["display_campaign_dfp_id"], name: "index_ad_unit_display_campaigns_on_display_campaign_dfp_id", using: :btree

  create_table "ad_units", force: :cascade do |t|
    t.string   "name"
    t.integer  "dfp_id",     limit: 8
    t.integer  "status"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_units", ["dfp_id"], name: "index_ad_units_on_dfp_id", using: :btree

  create_table "ads", force: :cascade do |t|
    t.string   "headline"
    t.string   "description_first_line"
    t.string   "description_second_line"
    t.string   "link"
    t.integer  "ad_group_id",             limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "external_id",             limit: 8
    t.string   "status"
    t.string   "type"
  end

  add_index "ads", ["ad_group_id", "external_id"], name: "index_ads_on_ad_group_id_and_external_id", using: :btree
  add_index "ads", ["ad_group_id"], name: "index_ads_on_ad_group_id", using: :btree
  add_index "ads", ["external_id", "type"], name: "index_ads_on_external_id_and_type", unique: true, using: :btree
  add_index "ads", ["external_id"], name: "index_ads_on_external_id", using: :btree

  create_table "advertisers_users", force: :cascade do |t|
    t.integer "advertiser_id"
    t.integer "user_id"
  end

  create_table "adwords_ad_group_stat_clicks", force: :cascade do |t|
    t.integer  "adwords_ad_group_id",    limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.string   "click_type",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
  end

  add_index "adwords_ad_group_stat_clicks", ["adwords_ad_group_id", "date", "click_type"], name: "adwords_ad_group_stat_clicks_unique", unique: true, using: :btree

  create_table "adwords_ad_group_stat_clicks_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "adwords_ad_group_id",    limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.string   "click_type",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
  end

  create_table "adwords_ad_group_stat_devices", force: :cascade do |t|
    t.integer  "adwords_ad_group_id",    limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.string   "device",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
    t.decimal  "impression_share"
  end

  add_index "adwords_ad_group_stat_devices", ["adwords_ad_group_id", "date", "device"], name: "adwords_ad_group_stat_devices_unique", unique: true, using: :btree

  create_table "adwords_ad_group_stat_devices_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "adwords_ad_group_id",    limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.string   "device",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
    t.decimal  "impression_share"
  end

  create_table "adwords_ad_group_stat_networks", force: :cascade do |t|
    t.integer  "adwords_ad_group_id",    limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.string   "network",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
    t.decimal  "impression_share"
  end

  add_index "adwords_ad_group_stat_networks", ["adwords_ad_group_id", "date", "network"], name: "adwords_ad_group_stat_networks_unique", unique: true, using: :btree

  create_table "adwords_ad_group_stat_networks_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "adwords_ad_group_id",    limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.string   "network",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
    t.decimal  "impression_share"
  end

  create_table "adwords_ad_group_stats", force: :cascade do |t|
    t.integer  "adwords_ad_group_id",    limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
    t.decimal  "impression_share"
  end

  add_index "adwords_ad_group_stats", ["adwords_ad_group_id", "date"], name: "adwords_ad_group_stat_index_id_date", using: :btree
  add_index "adwords_ad_group_stats", ["adwords_ad_group_id", "date"], name: "index_adwords_ad_group_stats_on_adwords_ad_group_id_and_date", unique: true, using: :btree
  add_index "adwords_ad_group_stats", ["adwords_ad_group_id"], name: "index_adwords_ad_group_stats_on_adwords_ad_group_id", using: :btree
  add_index "adwords_ad_group_stats", ["date"], name: "index_adwords_ad_group_stats_on_date", using: :btree

  create_table "adwords_ad_group_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "adwords_ad_group_id",    limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
    t.decimal  "impression_share"
  end

  create_table "adwords_ad_groups_aggregations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "status"
    t.string  "name"
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "adwords_ad_groups_aggregations", ["user_id", "start_date", "end_date"], name: "ad_groups_stat_index", using: :btree

  create_table "adwords_ad_stats", force: :cascade do |t|
    t.integer  "adwords_ad_id",          limit: 8
    t.integer  "ad_group_id",            limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adwords_ad_stats", ["ad_group_id", "adwords_ad_id", "date"], name: "adwords_ad_stat_parent_index", using: :btree
  add_index "adwords_ad_stats", ["ad_group_id", "date"], name: "index_adwords_ad_stats_on_ad_group_id_and_date", using: :btree
  add_index "adwords_ad_stats", ["ad_group_id"], name: "index_adwords_ad_stats_on_ad_group_id", using: :btree
  add_index "adwords_ad_stats", ["adwords_ad_id", "date"], name: "index_adwords_ad_stats_on_adwords_ad_id_and_date", using: :btree
  add_index "adwords_ad_stats", ["adwords_ad_id"], name: "index_adwords_ad_stats_on_adwords_ad_id", using: :btree
  add_index "adwords_ad_stats", ["date"], name: "index_adwords_ad_stats_on_date", using: :btree

  create_table "adwords_ad_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "adwords_ad_id",          limit: 8
    t.integer  "ad_group_id",            limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adwords_ads_aggregations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "status"
    t.string  "headline"
    t.string  "description_first_line"
    t.string  "description_second_line"
    t.string  "link"
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "adwords_ads_aggregations", ["user_id", "start_date", "end_date"], name: "ads_stat_index", using: :btree

  create_table "adwords_keyword_stats", force: :cascade do |t|
    t.integer  "adwords_keyword_id",     limit: 8
    t.integer  "ad_group_id",            limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.integer  "first_page_cpc",         limit: 8
    t.integer  "top_of_page_cpc",        limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "impression_share"
  end

  add_index "adwords_keyword_stats", ["ad_group_id", "adwords_keyword_id", "date"], name: "adwords_keyword_stat_parent_index", using: :btree
  add_index "adwords_keyword_stats", ["ad_group_id", "date"], name: "index_adwords_keyword_stats_on_ad_group_id_and_date", using: :btree
  add_index "adwords_keyword_stats", ["ad_group_id"], name: "index_adwords_keyword_stats_on_ad_group_id", using: :btree
  add_index "adwords_keyword_stats", ["adwords_keyword_id", "date"], name: "index_adwords_keyword_stats_on_adwords_keyword_id_and_date", using: :btree
  add_index "adwords_keyword_stats", ["adwords_keyword_id"], name: "index_adwords_keyword_stats_on_adwords_keyword_id", using: :btree
  add_index "adwords_keyword_stats", ["date"], name: "index_adwords_keyword_stats_on_date", using: :btree

  create_table "adwords_keyword_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "adwords_keyword_id",     limit: 8
    t.integer  "ad_group_id",            limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.integer  "first_page_cpc",         limit: 8
    t.integer  "top_of_page_cpc",        limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "impression_share"
  end

  create_table "adwords_keywords_aggregations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "status"
    t.string  "name"
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "adwords_keywords_aggregations", ["user_id", "start_date", "end_date"], name: "keyword_stat_index", using: :btree

  create_table "adwords_sem_campaign_stats", force: :cascade do |t|
    t.integer  "adwords_sem_campaign_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.string   "network"
    t.string   "click_type"
    t.string   "device"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
    t.decimal  "impression_share"
  end

  add_index "adwords_sem_campaign_stats", ["adwords_sem_campaign_id", "date", "device", "click_type", "network"], name: "adwords_campaign_stat_date_segments", using: :btree
  add_index "adwords_sem_campaign_stats", ["adwords_sem_campaign_id", "date", "network", "click_type", "device"], name: "adwords_sem_campaign_stats_unique", unique: true, using: :btree
  add_index "adwords_sem_campaign_stats", ["adwords_sem_campaign_id", "date"], name: "adwords_campaign_stat_index_id_date", using: :btree
  add_index "adwords_sem_campaign_stats", ["adwords_sem_campaign_id", "date"], name: "adwords_sem_campaign_and_date", using: :btree
  add_index "adwords_sem_campaign_stats", ["adwords_sem_campaign_id"], name: "adwords_campaign_stat_index_id", using: :btree
  add_index "adwords_sem_campaign_stats", ["adwords_sem_campaign_id"], name: "index_adwords_sem_campaign_stats_on_adwords_sem_campaign_id", using: :btree
  add_index "adwords_sem_campaign_stats", ["date"], name: "index_adwords_sem_campaign_stats_on_date", using: :btree
  add_index "adwords_sem_campaign_stats", ["device", "click_type", "network"], name: "adwords_campaign_stat_segments", using: :btree

  create_table "adwords_sem_campaign_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "adwords_sem_campaign_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.float    "ctr"
    t.float    "average_position"
    t.integer  "average_cost_per_click"
    t.string   "network"
    t.string   "click_type"
    t.string   "device"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "est_total_conv"
    t.decimal  "impression_share"
  end

  create_table "bing_ad_group_stats", force: :cascade do |t|
    t.integer  "bing_ad_group_id", limit: 8
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "average_position"
    t.float    "spend"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "impression_share"
  end

  add_index "bing_ad_group_stats", ["bing_ad_group_id", "date"], name: "index_bing_ad_group_stats_on_bing_ad_group_id_and_date", using: :btree
  add_index "bing_ad_group_stats", ["bing_ad_group_id"], name: "index_bing_ad_group_stats_on_bing_ad_group_id", using: :btree

  create_table "bing_ad_group_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "bing_ad_group_id", limit: 8
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "average_position"
    t.float    "spend"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "impression_share"
  end

  create_table "bing_ad_stats", force: :cascade do |t|
    t.integer  "bing_ad_id",       limit: 8
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "average_position"
    t.float    "spend"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bing_ad_stats", ["bing_ad_id", "date"], name: "index_bing_ad_stats_on_bing_ad_id_and_date", using: :btree
  add_index "bing_ad_stats", ["bing_ad_id"], name: "index_bing_ad_stats_on_bing_ad_id", using: :btree

  create_table "bing_ad_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "bing_ad_id",       limit: 8
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "average_position"
    t.float    "spend"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bing_keyword_stats", force: :cascade do |t|
    t.integer  "bing_keyword_id",  limit: 8
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "average_position"
    t.float    "spend"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bing_keyword_stats", ["bing_keyword_id", "date"], name: "index_bing_keyword_stats_on_bing_keyword_id_and_date", using: :btree
  add_index "bing_keyword_stats", ["bing_keyword_id"], name: "index_bing_keyword_stats_on_bing_keyword_id", using: :btree

  create_table "bing_keyword_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "bing_keyword_id",  limit: 8
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "average_position"
    t.float    "spend"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bing_sem_campaign_stats", force: :cascade do |t|
    t.integer  "bing_sem_campaign_id", limit: 8
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "spend"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "impression_share"
  end

  add_index "bing_sem_campaign_stats", ["bing_sem_campaign_id", "date"], name: "index_bing_sem_campaign_stats_on_bing_sem_campaign_id_and_date", using: :btree
  add_index "bing_sem_campaign_stats", ["bing_sem_campaign_id"], name: "index_bing_sem_campaign_stats_on_bing_sem_campaign_id", using: :btree

  create_table "bing_sem_campaign_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "bing_sem_campaign_id", limit: 8
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "spend"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "impression_share"
  end

  create_table "business_types", force: :cascade do |t|
    t.string  "name"
    t.integer "parent_id"
  end

  create_table "content_pages", force: :cascade do |t|
    t.text "page_path", null: false
  end

  add_index "content_pages", ["page_path"], name: "index_content_pages_on_page_path", unique: true, using: :btree

  create_table "creatives", force: :cascade do |t|
    t.string   "name"
    t.string   "size"
    t.string   "status"
    t.integer  "display_campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "creative_type"
    t.text     "preview_url"
    t.text     "image_url"
    t.string   "type"
    t.integer  "external_id",         limit: 8
  end

  add_index "creatives", ["display_campaign_id"], name: "index_creatives_on_display_campaign_id", using: :btree
  add_index "creatives", ["external_id", "display_campaign_id", "type"], name: "index_creatives_on_external_id_and_display_campaign_id_and_type", unique: true, using: :btree
  add_index "creatives", ["external_id", "type"], name: "index_creatives_on_external_id_and_type", using: :btree

  create_table "creatives_display_campaign_stats", force: :cascade do |t|
    t.integer  "creatives_display_campaign_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "ctr"
    t.date     "date"
    t.date     "collected_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "creatives_display_campaign_stats", ["creatives_display_campaign_id", "date"], name: "creatives_display_campaign_stats_index_id_date", unique: true, using: :btree
  add_index "creatives_display_campaign_stats", ["creatives_display_campaign_id"], name: "creatives_display_campaign_stat_ext", using: :btree
  add_index "creatives_display_campaign_stats", ["creatives_display_campaign_id"], name: "creatives_display_campaign_stats_index_id", using: :btree

  create_table "creatives_display_campaign_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "creatives_display_campaign_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "ctr"
    t.date     "date"
    t.date     "collected_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creatives_display_campaigns", force: :cascade do |t|
    t.integer  "display_campaign_id", null: false
    t.integer  "creative_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "creatives_display_campaigns", ["creative_id"], name: "index_creatives_display_campaigns_on_creative_id", using: :btree
  add_index "creatives_display_campaigns", ["display_campaign_id", "creative_id"], name: "index_creatives_dc_on_dc_and_creative_id", unique: true, using: :btree
  add_index "creatives_display_campaigns", ["display_campaign_id"], name: "index_creatives_display_campaigns_on_display_campaign_id", using: :btree

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "customer_id",    limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                   default: true
    t.string   "type"
    t.integer  "sem_manager_id"
  end

  add_index "customers", ["customer_id"], name: "index_customers_on_customer_id", using: :btree
  add_index "customers", ["name"], name: "index_customers_on_name", using: :btree
  add_index "customers", ["sem_manager_id"], name: "index_customers_on_sem_manager_id", using: :btree
  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "dfa_creative_stats", force: :cascade do |t|
    t.integer  "dfa_creative_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dfa_creative_stats", ["dfa_creative_id", "date"], name: "index_dfa_creative_stats_on_dfa_creative_id_and_date", unique: true, using: :btree
  add_index "dfa_creative_stats", ["dfa_creative_id"], name: "index_dfa_creative_stats_on_dfa_creative_id", using: :btree

  create_table "dfa_display_campaign_stats", force: :cascade do |t|
    t.integer  "dfa_display_campaign_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "ctr"
    t.date     "date"
    t.date     "collected_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dfa_display_campaign_stats", ["dfa_display_campaign_id", "date"], name: "dfa_campaign_stat_id_date", unique: true, using: :btree
  add_index "dfa_display_campaign_stats", ["dfa_display_campaign_id"], name: "index_dfa_display_campaign_stats_on_dfa_display_campaign_id", using: :btree

  create_table "dfp_creative_sets", force: :cascade do |t|
    t.integer  "external_id",             limit: 8
    t.integer  "master_creative_id",      limit: 8
    t.date     "last_modified_date_time"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dfp_creative_sets", ["external_id"], name: "index_dfp_creative_sets_on_external_id", using: :btree
  add_index "dfp_creative_sets", ["master_creative_id"], name: "index_dfp_creative_sets_on_master_creative_id", using: :btree

  create_table "dfp_creative_stats", force: :cascade do |t|
    t.integer  "dfp_creative_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dfp_creative_stats", ["dfp_creative_id", "date"], name: "index_dfp_creative_stats_on_dfp_creative_id_and_date", unique: true, using: :btree
  add_index "dfp_creative_stats", ["dfp_creative_id"], name: "index_dfp_creative_stats_on_dfp_creative_id", using: :btree

  create_table "dfp_creative_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "dfp_creative_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.date     "date"
    t.date     "collected_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dfp_display_campaign_stats", force: :cascade do |t|
    t.integer  "dfp_display_campaign_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "ctr"
    t.date     "date"
    t.date     "collected_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dfp_display_campaign_stats", ["dfp_display_campaign_id", "date"], name: "dfp_campaign_stat_id_date", unique: true, using: :btree
  add_index "dfp_display_campaign_stats", ["dfp_display_campaign_id"], name: "index_dfp_display_campaign_stats_on_dfp_display_campaign_id", using: :btree

  create_table "dfp_display_campaign_stats_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "dfp_display_campaign_id", limit: 8
    t.float    "cost"
    t.integer  "clicks"
    t.integer  "impressions"
    t.integer  "conversions"
    t.float    "ctr"
    t.date     "date"
    t.date     "collected_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "display_campaign_targets", force: :cascade do |t|
    t.integer  "target_dfp_id",           limit: 8, null: false
    t.integer  "display_campaign_dfp_id", limit: 8, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "display_campaign_targets", ["display_campaign_dfp_id"], name: "index_display_campaign_targets_on_display_campaign_dfp_id", using: :btree
  add_index "display_campaign_targets", ["target_dfp_id"], name: "index_display_campaign_targets_on_target_dfp_id", using: :btree

  create_table "display_campaigns", force: :cascade do |t|
    t.string   "name"
    t.string   "status"
    t.string   "site_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "dfp_network_code"
    t.boolean  "dependencies_imported",                 default: false, null: false
    t.integer  "order_id"
    t.string   "parsed_name"
    t.boolean  "ontarget",                              default: false
    t.string   "type"
    t.integer  "external_id",                 limit: 8
    t.text     "notes"
    t.integer  "contracted_impressions"
    t.float    "booked_revenue"
    t.float    "delivery_indicator"
    t.float    "previous_delivery_indicator"
  end

  add_index "display_campaigns", ["external_id", "type"], name: "index_display_campaigns_on_external_id_and_type", unique: true, using: :btree

  create_table "display_campaigns_orders", force: :cascade do |t|
    t.integer "display_campaign_id"
    t.integer "order_id"
  end

  create_table "display_campaigns_users", id: false, force: :cascade do |t|
    t.integer "user_id",             null: false
    t.integer "display_campaign_id", null: false
  end

  add_index "display_campaigns_users", ["display_campaign_id", "user_id"], name: "dc_user_index", unique: true, using: :btree
  add_index "display_campaigns_users", ["user_id", "display_campaign_id"], name: "user_dc_index", unique: true, using: :btree

  create_table "facebook_ad_accounts", force: :cascade do |t|
    t.string   "account_id"
    t.string   "ad_account_id"
    t.integer  "account_status"
    t.float    "age"
    t.string   "amount_spent"
    t.integer  "balance"
    t.string   "business_city"
    t.string   "business_country_code"
    t.string   "business_name"
    t.string   "business_state"
    t.string   "business_street"
    t.string   "business_street2"
    t.string   "business_zip"
    t.datetime "created_time"
    t.string   "currency"
    t.integer  "daily_spend_limit"
    t.string   "end_advertiser"
    t.string   "funding_source"
    t.integer  "is_personal"
    t.integer  "media_agency"
    t.string   "name"
    t.boolean  "offsite_pixels_tos_accepted"
    t.integer  "partner"
    t.integer  "spend_cap"
    t.string   "timezone_name"
    t.integer  "timezone_offset_hours_utc"
    t.integer  "tax_id_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "facebook_ad_accounts", ["user_id"], name: "index_facebook_ad_accounts_on_user_id", using: :btree

  create_table "facebook_ad_creatives", force: :cascade do |t|
    t.string   "creative_id"
    t.string   "title"
    t.string   "body"
    t.string   "name"
    t.string   "creative_object_id"
    t.string   "creative_object_url"
    t.string   "creative_object_story_id"
    t.string   "image_file"
    t.string   "image_hash"
    t.string   "image_url"
    t.string   "link_url"
    t.string   "run_status"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_ad_report_stats", force: :cascade do |t|
    t.string   "facebook_object_id"
    t.integer  "impressions"
    t.integer  "clicks"
    t.decimal  "spend"
    t.integer  "likes"
    t.integer  "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_ad_id"
    t.date     "date"
    t.integer  "frequency"
    t.decimal  "avg_cost_per_like"
    t.integer  "reach"
    t.decimal  "ctr"
    t.decimal  "cpm"
    t.decimal  "cpc"
    t.integer  "unique_clicks"
    t.decimal  "cost_per_unique_click"
    t.integer  "conversions"
    t.integer  "unique_conversions"
  end

  add_index "facebook_ad_report_stats", ["facebook_ad_id"], name: "index_facebook_ad_report_stats_on_facebook_ad_id", using: :btree

  create_table "facebook_adcampaign_groups", force: :cascade do |t|
    t.string   "adcampaign_group_id"
    t.string   "account_id"
    t.string   "objective"
    t.string   "name"
    t.string   "campaign_group_status"
    t.string   "buying_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_ad_account_id"
  end

  add_index "facebook_adcampaign_groups", ["facebook_ad_account_id"], name: "index_facebook_adcampaign_groups_on_facebook_ad_account_id", using: :btree

  create_table "facebook_adcampaigns", force: :cascade do |t|
    t.string   "adcampaign_id"
    t.string   "name"
    t.string   "account_id"
    t.string   "bid_type"
    t.string   "campaign_group_id"
    t.string   "campaign_status"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "updated_time"
    t.datetime "created_time"
    t.integer  "daily_budget"
    t.integer  "lifetime_budget"
    t.integer  "budget_remaining"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_adcampaign_group_id"
  end

  add_index "facebook_adcampaigns", ["facebook_adcampaign_group_id"], name: "index_facebook_adcampaigns_on_facebook_adcampaign_group_id", using: :btree

  create_table "facebook_ads", force: :cascade do |t|
    t.string   "ad_id"
    t.string   "account_id"
    t.string   "adgroup_status"
    t.string   "bid_type"
    t.string   "campaign_id"
    t.string   "campaign_group_id"
    t.integer  "created_time"
    t.string   "name"
    t.integer  "updated_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_adcampaign_id"
    t.integer  "facebook_ad_creative_id"
    t.boolean  "have_year_of_data",       default: false
  end

  add_index "facebook_ads", ["facebook_ad_creative_id"], name: "index_facebook_ads_on_facebook_ad_creative_id", using: :btree
  add_index "facebook_ads", ["facebook_adcampaign_id"], name: "index_facebook_ads_on_facebook_adcampaign_id", using: :btree

  create_table "facebook_applications", force: :cascade do |t|
    t.string   "app_id",                                    null: false
    t.string   "encrypted_app_secret"
    t.string   "encrypted_appsecret_proof"
    t.string   "name"
    t.string   "category"
    t.string   "subcategory"
    t.string   "icon_url"
    t.string   "link"
    t.string   "mobile_web_url"
    t.string   "logo_url"
    t.string   "company"
    t.string   "contact_email"
    t.string   "description"
    t.string   "namespace"
    t.string   "page_tab_default_name"
    t.string   "page_tab_url"
    t.string   "privacy_policy_url"
    t.string   "profile_section_url"
    t.string   "terms_of_service_url"
    t.string   "user_support_email"
    t.string   "user_support_url"
    t.string   "website_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",                  default: false
    t.string   "redirect_uri"
  end

  create_table "facebook_applications_users", force: :cascade do |t|
    t.integer "facebook_application_id"
    t.integer "facebook_user_id"
  end

  add_index "facebook_applications_users", ["facebook_application_id"], name: "index_facebook_applications_users_on_facebook_application_id", using: :btree
  add_index "facebook_applications_users", ["facebook_user_id"], name: "index_facebook_applications_users_on_facebook_user_id", using: :btree

  create_table "facebook_daily_page_stats", force: :cascade do |t|
    t.integer  "facebook_page_id"
    t.integer  "likes"
    t.integer  "comments"
    t.integer  "posts"
    t.integer  "shares"
    t.integer  "paid_reach"
    t.integer  "viral_reach"
    t.integer  "organic_reach"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_daily_page_stats", ["facebook_page_id"], name: "index_facebook_daily_page_stats_on_facebook_page_id", using: :btree

  create_table "facebook_page_demographics", force: :cascade do |t|
    t.string   "gender"
    t.string   "age_group"
    t.integer  "likes"
    t.string   "date"
    t.integer  "facebook_daily_page_stat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_page_demographics", ["facebook_daily_page_stat_id"], name: "index_facebook_page_demographics_on_facebook_daily_page_stat_id", using: :btree
  add_index "facebook_page_demographics", ["facebook_daily_page_stat_id"], name: "index_facebook_page_demographics_on_facebook_page_stat_id", using: :btree

  create_table "facebook_pages", force: :cascade do |t|
    t.text     "facebook_page_id"
    t.text     "about"
    t.string   "category"
    t.integer  "checkins"
    t.boolean  "is_published"
    t.string   "link"
    t.string   "name"
    t.string   "username"
    t.string   "website"
    t.string   "phone"
    t.integer  "likes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "have_year_of_data", default: false
  end

  add_index "facebook_pages", ["user_id"], name: "index_facebook_pages_on_user_id", using: :btree

  create_table "facebook_users", force: :cascade do |t|
    t.string   "facebook_user_id"
    t.string   "username"
    t.string   "name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "email"
    t.string   "link"
    t.string   "locale"
    t.integer  "timezone"
    t.text     "encrypted_user_access_token"
    t.string   "token_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "import_enabled",              default: true
    t.boolean  "is_admin",                    default: false
  end

  add_index "facebook_users", ["user_id"], name: "index_facebook_users_on_user_id", using: :btree

  create_table "form_submissions", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "zip"
    t.string   "company"
    t.string   "url"
    t.text     "comments"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "form_submissions", ["submitted_at"], name: "index_form_submissions_on_submitted_at", using: :btree

  create_table "form_submissions_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "zip"
    t.string   "company"
    t.string   "url"
    t.text     "comments"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "ga_cities", force: :cascade do |t|
    t.string  "name"
    t.decimal "latitude",     precision: 8, scale: 4
    t.decimal "longitude",    precision: 8, scale: 4
    t.integer "ga_region_id"
    t.integer "external_id"
  end

  add_index "ga_cities", ["ga_region_id", "external_id"], name: "index_ga_cities_on_ga_region_id_and_external_id", using: :btree
  add_index "ga_cities", ["ga_region_id", "name"], name: "index_ga_cities_on_ga_region_id_and_name", unique: true, using: :btree
  add_index "ga_cities", ["ga_region_id"], name: "index_ga_cities_on_ga_region_id", using: :btree
  add_index "ga_cities", ["name", "ga_region_id"], name: "index_ga_cities_on_name_and_ga_region_id", using: :btree

  create_table "ga_referrers", force: :cascade do |t|
    t.text    "source",                 null: false
    t.boolean "spam",   default: false, null: false
  end

  add_index "ga_referrers", ["source"], name: "index_ga_referrers_on_source", unique: true, using: :btree

  create_table "ga_regions", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "code"
  end

  add_index "ga_regions", ["country", "code"], name: "index_ga_regions_on_country_and_code", unique: true, using: :btree
  add_index "ga_regions", ["country", "name"], name: "index_ga_regions_on_country_and_name", using: :btree
  add_index "ga_regions", ["name"], name: "index_ga_regions_on_name", using: :btree

  create_table "ga_users_reports", force: :cascade do |t|
    t.integer "website_id"
    t.integer "users"
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "ga_users_reports", ["website_id", "start_date"], name: "index_ga_users_reports_on_website_id_and_start_date", using: :btree

  create_table "ga_users_reports_archive", id: false, force: :cascade do |t|
    t.integer "id"
    t.integer "website_id"
    t.integer "users"
    t.date    "start_date"
    t.date    "end_date"
  end

  create_table "hadoop_errors", force: :cascade do |t|
    t.string   "error_type"
    t.string   "message"
    t.text     "input"
    t.text     "backtrace"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "restarted_at"
    t.string   "type"
  end

  add_index "hadoop_errors", ["error_type"], name: "index_hadoop_errors_on_error_type", using: :btree

  create_table "hadoop_steps", force: :cascade do |t|
    t.string   "hash_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scope"
    t.string   "jobflow_id"
  end

  add_index "hadoop_steps", ["created_at"], name: "index_hadoop_steps_on_created_at", using: :btree

  create_table "industries", force: :cascade do |t|
    t.string   "code",       limit: 8, null: false
    t.string   "name",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "name"
    t.integer  "ad_group_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "external_id", limit: 8
    t.string   "status"
    t.string   "type"
  end

  add_index "keywords", ["ad_group_id", "external_id"], name: "index_keywords_on_ad_group_id_and_external_id", using: :btree
  add_index "keywords", ["ad_group_id"], name: "index_keywords_on_ad_group_id", using: :btree
  add_index "keywords", ["external_id", "type", "ad_group_id"], name: "index_keywords_on_external_id_and_type_and_ad_group_id", unique: true, using: :btree
  add_index "keywords", ["external_id"], name: "index_keywords_on_external_id", using: :btree

  create_table "kpis", force: :cascade do |t|
    t.string  "scope"
    t.string  "name"
    t.date    "date"
    t.integer "value"
  end

  add_index "kpis", ["scope", "date", "name"], name: "index_kpis_on_scope_and_date_and_name", unique: true, using: :btree

  create_table "landing_pages", force: :cascade do |t|
    t.string  "page_id"
    t.string  "url"
    t.string  "name"
    t.string  "status"
    t.integer "conversions"
  end

  add_index "landing_pages", ["page_id"], name: "index_landing_pages_on_page_id", using: :btree

  create_table "lead_tracking_campaigns", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tracking_token"
    t.string   "origin"
    t.integer  "landing_page_id"
    t.integer  "marchex_campaign_id", limit: 8
  end

  add_index "lead_tracking_campaigns", ["landing_page_id"], name: "index_lead_tracking_campaigns_on_landing_page_id", using: :btree
  add_index "lead_tracking_campaigns", ["marchex_campaign_id"], name: "idx_lead_tracking_campaigns_on_marchex_campaign_id", using: :btree
  add_index "lead_tracking_campaigns", ["tracking_token"], name: "index_lead_tracking_campaigns_on_tracking_token", using: :btree
  add_index "lead_tracking_campaigns", ["user_id", "marchex_campaign_id"], name: "idx_lead_tracking_campaigns_on_user_id_and_marchex_campaign_id", using: :btree
  add_index "lead_tracking_campaigns", ["user_id"], name: "index_lead_tracking_campaigns_on_user_id", using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "source_type"
    t.integer  "source_id"
    t.integer  "lead_tracking_campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating"
    t.text     "note"
  end

  add_index "leads", ["lead_tracking_campaign_id"], name: "index_leads_on_lead_tracking_campaign_id", using: :btree
  add_index "leads", ["source_id", "source_type"], name: "index_leads_on_source_id_and_source_type", using: :btree

  create_table "leads_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.string   "source_type"
    t.integer  "source_id"
    t.integer  "lead_tracking_campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating"
    t.text     "note"
  end

  create_table "location_reports", force: :cascade do |t|
    t.string  "country"
    t.date    "date"
    t.integer "website_id"
    t.integer "ga_region_id"
    t.integer "ga_city_id"
    t.float   "sessions"
    t.float   "new_sessions"
    t.float   "pageviews"
    t.float   "avg_session"
    t.float   "bounce_rate"
  end

  add_index "location_reports", ["country"], name: "index_location_reports_on_country", using: :btree
  add_index "location_reports", ["date", "website_id", "country", "ga_region_id", "ga_city_id"], name: "unique_location_report", unique: true, using: :btree
  add_index "location_reports", ["ga_region_id"], name: "index_location_reports_on_ga_region_id", using: :btree
  add_index "location_reports", ["website_id"], name: "index_location_reports_on_website_id", using: :btree

  create_table "location_reports_archive", id: false, force: :cascade do |t|
    t.integer "id"
    t.string  "country"
    t.date    "date"
    t.integer "website_id"
    t.integer "ga_region_id"
    t.integer "ga_city_id"
    t.float   "sessions"
    t.float   "new_sessions"
    t.float   "pageviews"
    t.float   "avg_session"
    t.float   "bounce_rate"
  end

  create_table "marchex_accounts", force: :cascade do |t|
    t.string "name"
    t.string "account_id"
    t.string "status"
  end

  add_index "marchex_accounts", ["account_id"], name: "index_marchex_accounts_on_account_id", using: :btree
  add_index "marchex_accounts", ["name"], name: "index_marchex_accounts_on_name", using: :btree

  create_table "marchex_campaigns", force: :cascade do |t|
    t.integer  "marchex_account_id", limit: 8, null: false
    t.integer  "phone_number_id",    limit: 8, null: false
    t.string   "marchex_campaignid",           null: false
    t.string   "display_name",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marchex_campaigns", ["marchex_account_id", "phone_number_id"], name: "idx_marchex_campaigns_on_marchex_account_id_and_phone_number_id", using: :btree

  create_table "mobile_reports", force: :cascade do |t|
    t.integer  "website_id"
    t.string   "device"
    t.integer  "visits"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mobile_reports", ["date", "website_id", "device"], name: "unique_mobile_reports", unique: true, using: :btree

  create_table "mobile_reports_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "website_id"
    t.string   "device"
    t.integer  "visits"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offline_events", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "title"
    t.string   "location"
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "all_day",     default: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name",        limit: 128,             null: false
    t.integer  "status",                  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_archived"
    t.integer  "dfp_id",      limit: 8
    t.integer  "user_id"
  end

  add_index "orders", ["dfp_id"], name: "index_orders_on_dfp_id", using: :btree

  create_table "orders_users", force: :cascade do |t|
    t.integer "order_id"
    t.integer "user_id"
  end

  create_table "phone_calls", force: :cascade do |t|
    t.string   "callid"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string   "inbound_number"
    t.string   "answered_by_number"
    t.string   "caller_name"
    t.string   "caller_number"
    t.string   "status"
    t.boolean  "recorded"
    t.integer  "ring_duration"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "url_expiration_date"
  end

  add_index "phone_calls", ["callid"], name: "index_phone_calls_on_callid", using: :btree
  add_index "phone_calls", ["started_at"], name: "index_phone_calls_on_started_at", using: :btree
  add_index "phone_calls", ["url_expiration_date"], name: "index_phone_calls_on_url_expiration_date", using: :btree

  create_table "phone_calls_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.string   "callid"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string   "inbound_number"
    t.string   "answered_by_number"
    t.string   "caller_name"
    t.string   "caller_number"
    t.string   "status"
    t.boolean  "recorded"
    t.integer  "ring_duration"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "url_expiration_date"
    t.string   "short_url"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string   "display_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sem_campaigns", force: :cascade do |t|
    t.integer  "external_id",               limit: 8
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                              default: "Active"
    t.integer  "lead_tracking_campaign_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "customer_id"
    t.string   "type"
  end

  add_index "sem_campaigns", ["customer_id", "external_id"], name: "index_sem_campaigns_on_customer_id_and_external_id", using: :btree
  add_index "sem_campaigns", ["external_id", "type"], name: "index_sem_campaigns_on_external_id_and_type", unique: true, using: :btree
  add_index "sem_campaigns", ["external_id"], name: "index_sem_campaigns_on_external_id", using: :btree
  add_index "sem_campaigns", ["lead_tracking_campaign_id"], name: "index_sem_campaigns_on_lead_tracking_campaign_id", using: :btree

  create_table "sem_managers", force: :cascade do |t|
    t.string "name"
    t.string "access_token"
    t.string "refresh_token"
    t.string "token_issued_at"
  end

  create_table "sms_notifications", force: :cascade do |t|
    t.integer  "lead_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "retry_count",          default: 0
    t.integer  "temporary_api_key_id"
  end

  create_table "targets", force: :cascade do |t|
    t.string   "name",                 null: false
    t.integer  "dfp_id",     limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "targets", ["dfp_id"], name: "index_targets_on_dfp_id", using: :btree

  create_table "temporary_api_keys", force: :cascade do |t|
    t.string   "temporary_key"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clicks"
  end

  add_index "temporary_api_keys", ["temporary_key"], name: "temporary_key_uniq", unique: true, using: :btree

  create_table "top_content_reports", force: :cascade do |t|
    t.float    "visits"
    t.float    "pageviews"
    t.float    "time_on_page"
    t.date     "date"
    t.integer  "website_id",      limit: 8
    t.datetime "created_at"
    t.float    "bounce_rate"
    t.datetime "updated_at"
    t.integer  "unique_views"
    t.integer  "exits"
    t.integer  "content_page_id"
  end

  add_index "top_content_reports", ["date", "website_id", "content_page_id"], name: "unique_top_content_report", unique: true, using: :btree
  add_index "top_content_reports", ["website_id", "date"], name: "index_top_content_reports_on_website_id_and_date", using: :btree

  create_table "top_content_reports_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.float    "visits"
    t.float    "pageviews"
    t.float    "time_on_page"
    t.date     "date"
    t.integer  "website_id",      limit: 8
    t.datetime "created_at"
    t.float    "bounce_rate"
    t.datetime "updated_at"
    t.integer  "unique_views"
    t.integer  "exits"
    t.integer  "content_page_id"
  end

  create_table "top_referring_reports", force: :cascade do |t|
    t.float    "visits"
    t.float    "pageviews"
    t.float    "avg_time_on_site"
    t.date     "date"
    t.integer  "website_id",       limit: 8
    t.datetime "created_at"
    t.float    "bounce_rate"
    t.datetime "updated_at"
    t.integer  "ga_referrer_id"
  end

  add_index "top_referring_reports", ["date", "website_id", "ga_referrer_id"], name: "unique_top_referring_report", unique: true, using: :btree
  add_index "top_referring_reports", ["website_id", "date"], name: "index_top_referring_reports_on_website_id_and_date", using: :btree

  create_table "top_referring_reports_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.float    "visits"
    t.float    "pageviews"
    t.float    "avg_time_on_site"
    t.date     "date"
    t.integer  "website_id",       limit: 8
    t.datetime "created_at"
    t.float    "bounce_rate"
    t.datetime "updated_at"
    t.integer  "ga_referrer_id"
  end

  create_table "traffic_channels_reports", force: :cascade do |t|
    t.integer  "website_id",       limit: 8
    t.string   "channel"
    t.integer  "visits"
    t.float    "pageviews"
    t.float    "avg_time_on_site"
    t.float    "bounce_rate"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "traffic_channels_reports", ["date", "website_id", "channel"], name: "unique_traffic_channels_report", unique: true, using: :btree

  create_table "traffic_channels_reports_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.integer  "website_id",       limit: 8
    t.string   "channel"
    t.integer  "visits"
    t.float    "pageviews"
    t.float    "avg_time_on_site"
    t.float    "bounce_rate"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "traffic_metrics_reports", force: :cascade do |t|
    t.float    "visits"
    t.float    "pageviews"
    t.float    "avg_time_on_site"
    t.float    "new_visits"
    t.float    "pageviews_per_visit"
    t.float    "visit_bounce_rate"
    t.date     "date"
    t.integer  "website_id",          limit: 8
    t.float    "bounce"
    t.float    "time_on_site"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users"
  end

  add_index "traffic_metrics_reports", ["date", "website_id"], name: "index_traffic_metrics_reports_on_date_and_website_id", using: :btree

  create_table "traffic_metrics_reports_archive", id: false, force: :cascade do |t|
    t.integer  "id"
    t.float    "visits"
    t.float    "pageviews"
    t.float    "avg_time_on_site"
    t.float    "new_visits"
    t.float    "pageviews_per_visit"
    t.float    "visit_bounce_rate"
    t.date     "date"
    t.integer  "website_id",          limit: 8
    t.float    "bounce"
    t.float    "time_on_site"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users"
  end

  create_table "usage_stats", force: :cascade do |t|
    t.string   "path"
    t.string   "url"
    t.string   "start_date"
    t.string   "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "details"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.text     "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "adwords_client_id"
    t.string   "account_name"
    t.string   "logo_url"
    t.boolean  "low_transparency",          default: false
    t.string   "api_key"
    t.string   "analytics_access_token"
    t.string   "analytics_refresh_token"
    t.string   "analytics_token_issued_at"
    t.string   "rep_name"
    t.string   "rep_email"
    t.string   "rep_phone"
    t.float    "sem_margin",                default: 0.0
    t.boolean  "has_analytics"
    t.date     "ga_collected_on"
    t.date     "ga_first_collected_on"
    t.integer  "industry_id"
    t.string   "mobile_phone"
    t.boolean  "sms_notifications_enabled", default: false
    t.integer  "business_type_id"
    t.decimal  "facebook_margin"
    t.boolean  "allowed_comparison",        default: false, null: false
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", unique: true, using: :btree

  create_table "users_websites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "website_id"
  end

  add_index "users_websites", ["user_id", "website_id"], name: "index_users_websites_on_user_id_and_website_id", unique: true, using: :btree

  create_table "websites", force: :cascade do |t|
    t.string  "name"
    t.integer "external_id", limit: 8
    t.integer "industry",              default: 0, null: false
  end

  add_index "websites", ["external_id"], name: "index_websites_on_external_id", unique: true, using: :btree

  add_foreign_key "facebook_ads", "facebook_ad_creatives"
end
