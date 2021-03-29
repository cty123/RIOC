require 'rioc/bean/bean'
require 'rioc/bean/factory'
require 'rioc/errors'
require 'set'

module Rioc
  # Rioc container class that is responsible for storing all the beans definitions as well as live instance
  # of the beans declared.
  class RiocContainer

    # Initialize the IoC container
    def initialize
      @container = {}
      @beans = {}
      @in_recursion = false
    end

    # Register a instance without any need of resolving dependencies
    def register(name, scope: Rioc::Bean::Scope::SINGLETON, lazy: false, &block)
      @beans[name] = Rioc::Bean::RiocBean.new(name,
                                              Rioc::Bean::BeanFactory.new(self, name, block),
                                              scope,
                                              lazy)

    end

    # Resolve bean with the provided bean name
    def resolve(name)
      # Should panic if the bean name is never registered
      raise UnknownDependencyNameError, name unless @beans[name]

      bean = @beans[name]

      # If the bean already exists in the container and the scope is singleton,
      # directly return the bean instance
      return @container[name] if @container[name] && bean.scope == Rioc::Bean::Scope::SINGLETON

      # Call the internal function to create the bean instance and return it
      resolve_bean(name)
    end

    # Build container
    def build_container
      @beans.each { |name, _| resolve(name) }
    end

    # Start application
    def start_application; end

    private

    def resolve_bean(bean)
      # We need to know if we are recursively resolving the dependencies
      # in order to detect cyclic dependencies
      unless @in_recursion
        @in_recursion = true

        @visited = Set.new
        @built = Set.new

        instance = build_bean(bean)

        @in_recursion = false
        return instance
      end

      # Check if it has cyclic dependency
      raise Rioc::Errors::CyclicDependencyError, bean if @visited.include?(bean) && !@built.include?(bean)

      # Resolve current dependencies before building the instance
      build_bean(bean)
    end

    def build_bean(bean)
      @visited.add(bean)
      instance = @beans[bean].factory.build_instance
      @container[bean] = instance if @beans[bean].scope == Rioc::Bean::Scope::SINGLETON
      @built.add(bean)
      instance
    end

  end
end
