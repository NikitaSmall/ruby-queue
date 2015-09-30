require 'celluloid/current'

module Handlers
  class Ender
    include Celluloid

    def run(task)
      options = task.argument
      task.finished
    end

  end
end
