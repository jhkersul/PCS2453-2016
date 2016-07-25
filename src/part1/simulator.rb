require './processor'
require './device'
require './job'
require './event'
require './event_list'
require './main_memory'

=begin
Classe Simulator
É o simulador em si, esta classe gerencia as execuções do simulador
=end
class Simulator
  attr_accessor :simulation_log, :initial_instant, :final_instant, :current_instant, :event_list, :jobs_table

  # Carregando dados na inicialização do simulador
  def initialize(initial_instant, final_instant, jobs_table)
    @initial_instant = initial_instant
    @final_instant = final_instant
    @jobs_table = jobs_table
    @current_instant = @initial_instant
  end

  # Rodar simulador
  def run
    # Instanciando objetos
    processor = Processor.new(self)
    memory = MainMemory.new(1000, 10)


    # Formando lista inicial de eventos
    @event_list = EventList.new
    jobs_table.each do |job|
      event = Event.new(Event.id_arrival, job, job.arrival_time)
      @event_list.add(event)
    end


    while !@event_list.empty? && @current_instant < @final_instant
      current_event = @event_list.next
      current_job = current_event.job

      case current_event.id
        when Event.arrival
          @event_list.add(Event.new(Event.request_cm, current_job, current_job.total_time))
          add_event_to_log(@current_instant, 'CHEGADA', current_job.name, 'JOB REQUISITA MEMÓRIA', 'EVENTO NOVO ADICIONADO NA LISTA')
        when Event.request_cm


      end


      processor.clock

    end

    print_log
  end

  # Verifica se existe algum evento com um determinado arrival_time
  def get_event_arrival_time(arrival_time)
    events.each do |event|
      if event.arrival_time == arrival_time
        return event
      end
    end

    nil
  end


  # Imprime o log de saída da simulação
  # Formato da Saída:
  # <instante> <tipo de evento> <identificação do programa> <ação executada> <resultado>
  def print_log
    # Se o log é nulo, sair do loop
    return if @simulation_log.nil?

    # O objeto "simulation_log" armazena os dados da simulação
    @simulation_log.each do |log|
      # Imprimindo o instante
      puts "\n"
      puts "INSTANTE: #{log[0]}"
      puts "TIPO DE EVENTO: #{log[1]}"
      puts "IDENTIFICAÇÃO DO PROGRAMA: #{log[2]}"
      puts "AÇÃO EXECUTADA: #{log[3]}"
      puts "RESULTADO: #{log[4]}"
      puts "\n"
    end

  end

  def add_event_to_log(instant, event_type, identification, action, result)
    @simulation_log ||= [] # Se o log for nulo, fazer dele um array

    log ||= []
    log[0] = instant
    log[1] = event_type
    log[2] = identification
    log[3] = action
    log[4] = result

    @simulation_log << log
  end
end
