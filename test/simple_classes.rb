class AClass
  def initialize(b, text)
    puts "init A: #{b}, #{text}"
    @b_instance = b
  end

  def do_something
    puts "BClass instance #{@b_instance}"
  end
end

class BClass
  def initialize(c, d)
    puts "init B"
  end
end

class CClass
  def initialize(e)
    puts "init C"
  end
end

class DClass
  def initialize(c, e)
    puts "init D"
  end
end

class EClass
  def initialize
    puts "init E"
  end
end