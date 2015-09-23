require 'active_support/core_ext/module/delegation'
module GAMapper
  class ApiResponse
    attr_reader :raw_response

    delegate :headers, to: :raw_response, prefix: :response

    def initialize(raw_response)
      @raw_response = raw_response
    end

    def body
      @parsed_response ||= JSON.parse(raw_response.body)
    end

    def success?
      status_code == 200
    end

    def error_reason
      body['error']["errors"][0]['reason'] rescue nil
    end

    def status_code
      @raw_response.status.to_i
    end

    def retriable?
      [403, 503].include? status_code
    end

    def each_row
      Array(body['rows']).each do |row|
        yield row
      end
    end

    def each_hash
      each_row do |row|
        yield Hash[headers.keys.zip(row)]
      end
    end
    alias_method :each, :each_hash

    def start_date
      Date.parse(query['start-date'])
    end

    def end_date
      Date.parse(query['end-date'])
    end

    def headers
      @headers ||= body['columnHeaders'].inject({}) { |memo, header| memo.update(header["name"] => header) }
    end

    def totals
      body['totalsForAllResults']
    end

    def total_results
      body['totalResults']
    end

    def query
      body['query']
    end

    def error
      body['error']
    end

    def profile_info
      body.fetch('profileInfo', {})
    end

  end
end
