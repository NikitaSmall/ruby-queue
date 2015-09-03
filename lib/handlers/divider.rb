module Handlers
  class Devider
    attr_accessor :a, :b

    def initialize(options)
      @a = options["a"]
      @b = options["b"]
    end

    def devide
      begin
      rescue => e
      end
      @a / @b
    end

    def run
      puts devide
    end
  end
end
