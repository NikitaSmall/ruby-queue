require 'celluloid/current'

module Handlers
  module Adwords
    module KeywordStats
      class KeywordStatsParser
        include Celluloid

        def run(task)
          options = task.argument

          p options["response"]
        end

      end
    end
  end
end
