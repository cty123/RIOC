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

      # Used to resolve dependencies
      @visited = Set.new
      @built = Set.new
    end

    # Register a instance without any need of resolving dependencies
    def register(name, scope: Rioc::Bean::Scope::SINGLETON, lazy: false, &block)
      @beans[name] = Rioc::Bean::RiocBean.new(name,
                                              Rioc::Bean::BeanFactory.new(self, name, block),
                                              scope,
                                              lazy)

    end

    # Resolve bean with the provided bean name
    # @param name - The name of the bean to resolve
    # @return A live instance of the bean definition
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
      @beans
        .reject { |name| @beans[name].lazy }
        .each { |name, _| resolve(name) }
    end

    # Start application
    def start_application; end

    private

    # Internal method to resolve bean if the bean doesn't have an instance
    # in container or the bean is transient.
    def resolve_bean(bean)
      # We need to know if we are recursively resolving the dependencies
      # in order to detect cyclic dependencies
      unless @in_recursion
        @in_recursion = true
        clear_dfs_history

        instance = build_bean(bean)

        @in_recursion = false
        clear_dfs_history
        return instance
      end

      # Check if it has cyclic dependency
      raise Rioc::Errors::CyclicDependencyError, bean if @visited.include?(bean) && !@built.include?(bean)

      # Resolve current dependencies before building the instance
      build_bean(bean)
    end

    # Internal method to instantiate a new bean
    def build_bean(bean)
      @visited.add(bean)
      instance = @beans[bean].factory.build_instance
      @container[bean] = instance if @beans[bean].scope == Rioc::Bean::Scope::SINGLETON
      @built.add(bean)
      instance
    end

    # Internal method to clear the history of the DFS search to resolve a bean
    def clear_dfs_history
      @visited.clear
      @built.clear
    end
  end
end
