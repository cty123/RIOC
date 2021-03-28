module Rioc
  module Bean
    class BeanFactory

      # Initialize the dependency factory class to build the dependency
      # whenever the dependency is needed.
      def initialize(name, block, params: [])
        @name = name
        @block = block
        @params = params
      end

      def build_instance(dependencies: {})
        return @block.call if @params.empty?

        deps = @params.map do |p|
          next p unless p.instance_of?(Rioc::Resolve)

          dependencies[p.name]
        end

        @block.call(*deps)
      end

    end
  end
end
