require_relative 'test_helper'
require_relative 'simple_classes'

class RiocTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rioc::VERSION
  end

  def test_simple_dependency_resolving
    container = Rioc::RiocContainer.new

    container.register(:A) { |c| AClass.new(c.resolve(:B), "hello")}
    container.register(:B) { |c| BClass.new(c.resolve(:C), c.resolve(:D)) }
    container.register(:C) { |c| CClass.new(c.resolve(:E)) }
    container.register(:D) { |c| DClass.new(c.resolve(:C), c.resolve(:E)) }
    container.register(:E) { EClass.new }

    container.build_container
    a_instance = container.resolve(:A)
    a_instance.do_something
  end

  def test_new
    c = Rioc::RiocContainer.new
    c.register(:A) do
      AClass.new("B", "Test")
    end
    c.resolve(:A)
  end
end
