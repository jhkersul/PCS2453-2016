=begin
Classe Event
Responsável por definir o comportamento de um processo
=end
class Event

  attr_accessor :id, :job, :event_time

  def initialize(id, job, event_time)
    @id = id
    @job = job
    @event_time = event_time
  end

  @@arrival = 1
  @@request_cm = 2
  @@request_cpu = 3
  @@release_cpu = 4
  @@request_io = 5
  @@release_io = 6
  @@release_cm = 7
  @@completion = 8

  def arrival
    @@arrival
  end
  def request_cm
    @@request_cm
  end
  def request_cpu
    @@request_cpu
  end
  def release_cpu
    @@release_cpu
  end
  def request_io
    @@request_io
  end
  def release_io
    @@release_io
  end
  def release_cm
    @@release_cm
  end
  def completion
    @@completion
  end



end