require_relative 'test_helper'
require_relative 'simple_classes'

class RiocTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rioc::VERSION
  end

  def test_it_does_something_useful

    c = Rioc::RiocContainer.new

    c.register_with_resolve(:A, AClass, Rioc::Resolve.new(:B), "hello")
    c.register_with_resolve(:B, BClass, Rioc::Resolve.new(:C), Rioc::Resolve.new(:D))
    c.register_with_resolve(:C, CClass, Rioc::Resolve.new(:E))
    c.register_with_resolve(:D, DClass, Rioc::Resolve.new(:C), Rioc::Resolve.new(:E))
    c.register(:E) { EClass.new }

    c.build_container
    a = c.resolve(:A)
  end
end
