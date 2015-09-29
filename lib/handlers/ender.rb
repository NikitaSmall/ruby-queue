require 'celluloid/current'

module Handlers
  class Ender
    include Celluloid

    def run(task)
      task.finished
    end
  end
end
