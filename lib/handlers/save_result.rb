require 'celluloid/current'

module Handlers
  class SaveResult
    include Celluloid

    def run(options, task)
      value_to_save = JSON::parse options["value_to_save"]

      save(options["model"], value_to_save)
      task.finished
    end

    private
    def save(model, value_to_save)
      Object.const_get(model).create(value_to_save)
    end
  end
end
