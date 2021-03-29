module Rioc
  module Bean
    class BeanFactory

      # Initialize the dependency factory class to build the dependency
      # whenever the dependency is needed.
      def initialize(container, name, block)
        @container = container
        @name = name
        @block = block
      end

      def build_instance
        @block.call(@container)
      end

    end
  end
end
