module Rioc
  module Bean

    class Scope

      SINGLETON = :singleton

      TRANSIENT = :transient

    end

    # RiocBean class
    class RiocBean

      attr_reader :name, :dependencies, :factory, :scope

      def initialize(name, dependencies, factory, scope)
        @name = name
        @dependencies = dependencies
        @factory = factory
        @scope = scope
      end

    end

  end
end
