
class Device
  attr_accessor :queue, :time_per_io, :total_time, :busy

  def initialize(time_per_io)
    @queue = Queue.new
    @time_per_io = time_per_io
    @busy = false
  end

  def request(job, time)
    if @busy
      @queue.add_job(job, time)
    else
      @busy = true
      @total_time = @time_per_io * job.io_operations
      job.io_operations = 0
    end
  end

  def release
    @busy = false
    if @queue.empty?
      nil
    else
      @queue.next
    end
  end



end