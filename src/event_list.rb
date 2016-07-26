
=begin
Classe EventList
Classe responsável por controlar a lista de eventos
=end
class EventList

  ## Variáveis
  # events - Array de eventos
  attr_accessor :events

  def initialize
    @events = []
  end

  # Adiciona evento à lista
  def add(event)
    @events << event

    # Organizando lista de eventos pelo tempo de execução
    @events.sort_by {|e| e.event_time}
  end

  # Pega próximo evento
  def next
    @events.shift
  end

  # Verifica se lista de eventos está vazia
  def empty?
    @events.empty?
  end

end