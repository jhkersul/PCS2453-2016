
class Device
  attr_accessor :queue, :time_per_io

  def initialize(time_per_io)
    @queue = Queue.new
    @time_per_io = time_per_io
  end

end