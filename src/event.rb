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

  ARRIVAL = 1
  REQUEST_CM = 2
  REQUEST_CPU = 3
  PROCESS_CPU = 4
  RELEASE_CPU = 5
  REQUEST_IO = 6
  RELEASE_IO = 7
  RELEASE_CM = 8
  COMPLETION = 9



end