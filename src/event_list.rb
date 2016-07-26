
class EventList

  attr_accessor :events

  def initialize
    @events = []
  end

  def add(event)
    @events << event

    # Organizando lista de eventos pelo tempo de execução
    @events.sort_by {|e| e.event_time}
  end

  def next
    @events.shift
  end

  def empty?
    @events.empty?
  end

end