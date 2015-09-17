require 'celluloid/current'

module Handlers
  class Devider
    include Celluloid

    def devide(a, b)
      a / b
    end

    def run(options)
      puts devide(options["a"], options["b"])
    end
  end
end
