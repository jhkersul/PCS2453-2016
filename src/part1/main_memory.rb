
class MainMemory

  attr_accessor :mem_size, :io_time, :queue, :content

  def initialize(mem_size, io_time)
    @queue = Queue.new
    @mem_size = mem_size
    @io_time = io_time
    @content = Array.new(@mem_size, 0)
  end

  def access_memory

  end

end