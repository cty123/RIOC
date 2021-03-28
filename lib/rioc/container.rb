require 'rioc/bean/bean'
require 'rioc/bean/factory'
require 'rioc/errors'
require 'set'

module Rioc
  # RiocContainer class
  class RiocContainer

    # Initialize the IoC container
    def initialize
      @container = {}
      @beans = {}
    end

    # Register a class with resolving the dependencies
    def register_with_resolve(name, klass, *params, scope: Rioc::Bean::Scope::SINGLETON, lazy: false)
      dependencies = params
                     .select { |p| p.instance_of?(Rioc::Resolve) }
                     .map(&:name)
      @beans[name] = Rioc::Bean::RiocBean.new(name,
                                              dependencies,
                                              Rioc::Bean::BeanFactory.new(name,
                                                                          ->(*ps) { klass.new(*ps) },
                                                                          params: params),
                                              scope)
    end

    # Register a instance without any need of resolving dependencies
    def register(name, scope: Rioc::Bean::Scope::SINGLETON, lazy: false, &block)
      @beans[name] = Rioc::Bean::RiocBean.new(name,
                                              [],
                                              Rioc::Bean::BeanFactory.new(name, block),
                                              scope)

    end

    # Resolve bean with the provided name
    def resolve(name)
      # Should panic if the bean name is never registered
      raise UnknownDependencyNameError, name unless @beans[name]

      bean = @beans[name]

      # If the bean already exists in the container and the scope is singleton,
      # directly return the bean instance
      @container[name] if @container[name] && bean.scope == Rioc::Bean::Scope::SINGLETON

      # Need to create the bean
      resolve_bean(name)
    end

    # Build container
    def build_container
      @beans.each { |name, _| resolve_bean(name) }
    end

    # Start application
    def start_application; end

    private

    def resolve_bean(bean)
      # Resolve current dependencies before building the instance
      resolve_dependencies(bean)
    end

    def resolve_dependencies(bean, visited: {}, built: {})
      # Check if it has cyclic dependency
      raise Rioc::Errors::CyclicDependencyError, bean if visited[bean] && !built[bean]

      # If bean has an life instance and the scope is singleton
      # we can simply return it
      if @beans[bean].scope == Rioc::Bean::Scope::SINGLETON
        return @container[bean] if @container[bean]
        return built[bean] if built[bean]
      end

      visited[bean] = true

      # Resolve all the dependencies of the bean before building it
      params = @beans[bean].dependencies.map do |dep|

        # If the bean is alive in new built instance list and scope is Singleton, fetch it from built list
        next [dep, built[dep]] if built[dep] && @beans[dep].scope == Rioc::Bean::Scope::SINGLETON

        # If the bean is alive in container and scope is Singleton, fetch it from container
        if @container[dep] && @beans[dep].scope == Rioc::Bean::Scope::SINGLETON
          built[dep] = @container[dep]
          next [dep, @container[dep]]
        end

        # Recursively resolve the dependency
        instance = resolve_dependencies(dep, visited: visited, built: built)
        built[dep] = instance
        [dep, built[dep]]
      end

      # Should have all the dependencies resolved, build the instance
      instance = @beans[bean].factory.build_instance(dependencies: params.to_h)

      @container[bean] = instance if @beans[bean].scope == Rioc::Bean::Scope::SINGLETON
      built[bean] = instance
      instance
    end

  end
end
