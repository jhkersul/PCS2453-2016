
class Device
  attr_accessor :queue

  def initialize
    @queue = Queue.new
  end

end