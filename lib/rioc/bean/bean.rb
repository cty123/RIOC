module Rioc
  module Bean
    # Defines the scope of the bean
    class Scope
      # Single instance throughout the entire lifetime of the framework.
      SINGLETON = :singleton

      # Create a new instance every time the bean is requested to be resolved.
      TRANSIENT = :transient
    end

    # RiocBean class
    class RiocBean

      attr_reader :name, :factory, :scope, :lazy

      def initialize(name, factory, scope, lazy)
        @name = name
        @factory = factory
        @scope = scope
        @lazy = lazy
      end

    end

  end
end
