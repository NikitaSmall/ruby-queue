module Handlers
  module ActorHelper
    LOGGER = Logger.new('logs/logfile.log')

    def actor_name(klass)
      klass.name.tableize.singularize.to_sym
    end

    def metrics
      self.class::METRICS
    end

    def dimensions
      self.class::DIMENSIONS
    end

    def filters
      self.class::FILTERS
    end

    def paginate_report(task, options, totalResults, target_handler)
      while options["params"]['start-index'] + ApiFactory::GA_MAX_RESULTS <= totalResults
        options["params"]['start-index'] += ApiFactory::GA_MAX_RESULTS
        options["target_handler"] = target_handler

        task.argument = options.to_json
        run_task_request(task) # to catch all the results
      end
    end

    def run_task_request(task)
      Celluloid::Actor[actor_name GoogleAnalytics::ApiClient].run task
    end

    def headers(response)
      response['columnHeaders'].map { |header| header["name"] }
    end

    def log(message, level = :info)
      message = 'Task: ' + message
      case level
      when :info
        LOGGER.info { message }
        STDERR.puts  'INFO: '  + message
      when :error
        LOGGER.error { message }
        STDERR.puts  'ERROR: '  + message
      else
        LOGGER.debug { message }
      end
    end
  end
end
