
class Block

  attr_accessor :name, :segment, :size

  def initialize(name, segment, size)
    @name = name
    @segment = segment
    @size = size
  end

end