module Handlers
  class Summ
    attr_accessor :a, :b

    def initialize(options)
      @a = options["a"]
      @b = options["b"]
    end

    def sum
      @a + @b
    end

    def run
      puts sum
    end
  end
end
