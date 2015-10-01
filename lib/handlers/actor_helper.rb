module Handlers
  module ActorHelper
    def actor_name(klass)
      klass.name.tableize.singularize.to_sym
    end

  end
end
