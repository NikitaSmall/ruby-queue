require 'adwords_api'
require 'dfp_api'
require 'google/api_client'
require 'rest_client'
require 'fileutils'

class ApiFactory
  unloadable
  TOKEN_LIFETIME = 3600
=begin
  PROPEL_DFP_AUTH_TOKEN = {
      access_token: ENV['DFP_ACCESS_TOKEN'],
      refresh_token: ENV['DFP_REFRESH_TOKEN'],
      issued_at: Time.parse(ENV['DFP_TOKEN_ISSUED_AT']),
      expires_in: TOKEN_LIFETIME,
  }
=end
  GA_MAX_RESULTS = 10_000

  def adwords_token(mcc)
    {
      access_token: mcc.access_token,
      refresh_token: mcc.refresh_token,
      issued_at: Time.parse(mcc.token_issued_at),
      expires_in: TOKEN_LIFETIME
    }
  end

  def adwords_api(customer_id)
    #TODO: Add updating MCC with token
    mcc = AdwordsCustomer.find_by_customer_id(customer_id).sem_manager
    api = AdwordsApi::Api.new(config)
    set_credentials(api, oauth2_token: adwords_token(mcc), client_customer_id: customer_id)
  end

  def dfp_api(token = PROPEL_DFP_AUTH_TOKEN, network_code = ENV['DFP_NETWORK_CODE'])
    api = DfpApi::Api.new(config)
    api.logger = Logger.new('/dev/null')
    set_credentials(api, oauth2_token: token, network_code: network_code)
  end

  def dfa_api
    client = Google::APIClient.new application_name: ENV['GOOGLE_APP_NAME']
    client.authorization = Signet::OAuth2::Client.new(
        token_credential_uri: URI.parse('https://accounts.google.com/o/oauth2/token'),
        authorization_uri: URI.parse('https://accounts.google.com/o/oauth2/auth'),
        client_id: ENV['ADWORDS_CLIENT_ID'],
        client_secret: ENV['ADWORDS_CLIENT_SECRET'],
        access_token: ENV['DFA_ACCESS_TOKEN'],
        refresh_token: ENV['DFA_REFRESH_TOKEN'],
        issued_at: Time.parse(ENV['DFA_TOKEN_ISSUED_AT']),
        expires_in: TOKEN_LIFETIME,
        auto_refresh_token: true
    )

    client
  end

  def unbounce_api
    RestClient::Resource.new "https://api.unbounce.com", ENV['UNBOUNCE_API_KEY']
  end

  def analytics_api(user)
    application_version = begin
      Darkwing::Application::VERSION
    rescue
      '1.0.0'
    end

    @analytics_clients ||= {}

    unless @analytics_clients[user.darkwing_user_id]
      client = Google::APIClient.new application_name: ENV['GOOGLE_APP_NAME'],
                                     application_version: application_version
      client.authorization = Signet::OAuth2::Client.new(
        token_credential_uri: URI.parse('https://accounts.google.com/o/oauth2/token'),
        authorization_uri: URI.parse('https://accounts.google.com/o/oauth2/auth'),
        client_id: ENV['ADWORDS_CLIENT_ID'],
        client_secret: ENV['ADWORDS_CLIENT_SECRET'],
        access_token: user.analytics_access_token,
        refresh_token: user.analytics_refresh_token,
        issued_at: user.analytics_token_issued_at,
        expires_in: TOKEN_LIFETIME,
        client_customer_id: ENV['ADWORDS_CLIENT_CUSTOMER_ID']
      )

      if client.authorization.expired?
        token = client.authorization.fetch_access_token!
        user.analytics_access_token = token['access_token']
        user.analytics_token_issued_at = Time.now
        user.update_darkwing
      end

      @analytics_clients[user.darkwing_user_id] = client
    end

    @analytics_clients[user.darkwing_user_id]
  end

  def discover_google_api(client, api, version)
    filename = discovery_document_filename(api, version)


    if !File.exists?(filename) || File.mtime(filename) > 1.day.ago
      File.open(filename, "w") { |f| f.puts JSON.generate(client.discovery_document(api, version) )}
    end

    doc = File.read(filename)
    client.register_discovery_document(api, version, doc) rescue nil # If cached discovery document invalid, ignore it and send direct discovery request to google
    client.discovered_api(api, version)
  end

  private
  def discovery_document_filename(api, version)
    File.join(tmp_dir, "#{api}_#{version}.json")
  end

  def tmp_dir
    dirname = File.join(APP_ROOT, 'tmp')
    FileUtils.mkdir_p dirname unless File.directory? dirname
    dirname
  end

  def config
    {
        authentication: {
            method: 'OAuth2',
            oauth2_client_id: ENV['ADWORDS_CLIENT_ID'],
            oauth2_client_secret: ENV['ADWORDS_CLIENT_SECRET'],
            oauth2_callback: ENV['ADWORDS_CALLBACK_URL'],
            developer_token: ENV['PROPEL_DEVELOPER_TOKEN'],
            user_agent: ENV['GOOGLE_USER_AGENT'],
            application_name: ENV['GOOGLE_APP_NAME'],
        },
        service: {
            environment: 'PRODUCTION'
        }
    }
  end

  def set_credentials(api, credentials)
    handler = api.credential_handler

    credentials.each do |key, value|
      handler.set_credential key, value
    end

    api
  end
end
