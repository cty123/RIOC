module Rioc

  module Errors

    # ApplicationUndeclaredError
    class ApplicationUndeclaredError < RuntimeError
      def initialize
        super('Application is not declared by user')
      end
    end

    class CyclicDependencyError < RuntimeError
      def initialize(name)
        super("Cyclic dependency detected at #{name}")
      end
    end

    # UnknownDependencyNameError
    class UnknownDependencyNameError < StandardError
      def initialize(name)
        super(msg: "Unknown dependency: #{name}, #{name} is not registered in RIOC container, ")
      end
    end

  end
end
