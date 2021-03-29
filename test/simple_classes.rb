class AClass
  def initialize(b, text)
    puts "init A: #{b}, #{text}"
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