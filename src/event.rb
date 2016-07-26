=begin
Classe Event
Responsável por definir o comportamento de um evento
=end
class Event

  ## Variáveis
  # id - Identificação do tipo de evento que estamos considerando
  # job - Job atendido por este evento
  # event_time - Instante que este evento começa
  attr_accessor :id, :job, :event_time

  ## Constantes para os tipos de evento possíveis
  ARRIVAL = 1
  REQUEST_CM = 2
  REQUEST_CPU = 3
  PROCESS_CPU = 4
  RELEASE_CPU = 5
  REQUEST_IO = 6
  RELEASE_IO = 7
  RELEASE_CM = 8
  COMPLETION = 9

  def initialize(id, job, event_time)
    @id = id
    @job = job
    @event_time = event_time
  end



end