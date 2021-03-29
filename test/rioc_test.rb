require_relative 'test_helper'
require_relative 'simple_classes'

class RiocTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rioc::VERSION
  end

  def test_it_does_something_useful

    container = Rioc::RiocContainer.new

    container.register(:A) { |c| AClass.new(c.resolve(:B), "hello")}
    container.register(:B) { |c| BClass.new(c.resolve(:C), c.resolve(:D)) }
    container.register(:C) { |c| CClass.new(c.resolve(:E)) }
    container.register(:D) { |c| DClass.new(c.resolve(:C), c.resolve(:E)) }
    container.register(:E) { EClass.new }

    container.build_container
    a = container.resolve(:A)
  end

  def test_new
    c = Rioc::RiocContainer.new
    c.register(:A) do
      AClass.new("B", "Test")
    end
    c.resolve(:A)
  end
end
