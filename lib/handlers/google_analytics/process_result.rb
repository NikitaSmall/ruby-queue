require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ProcessResult
      include Celluloid

      def run(options, materialized_path)
        profiles = JSON::parse options["profiles"]
        profiles.each do |profile|
          mapper_args = ["analytics", "Website", options["user_id"], profile['id'], profile['name'], profile['industryVertical']]
          process_result mapper_args.join(REDUCER_KEY_DELIMITER)
        end

        # create_task(options, materialized_path)
      end

      private
      def create_task(options, materialized_path)
        ::Task.create(handler: '', argument: options, materialized_path: materialized_path)
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

      def log(out)
        STDERR.puts "Output: #{out}"
      end

      def output(out)
        $stdout << out
      end
    end
  end
end
