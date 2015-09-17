require 'celluloid/current'

module Handlers
  class Summ
    include Celluloid

    def summ(a, b)
      a + b
    end

    def run(options)
      puts summ(options["a"], options["b"])
    end
  end
end
