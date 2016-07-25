require './processor'
require './device'
require './job'

=begin
Classe Simulator
É o simulador em si, esta classe gerencia as execuções do simulador
=end
class Simulator
  attr_accessor :simulation_log, :initial_instant, :final_instant, :current_instant, :events

  # Carregando dados na inicialização do simulador
  def initialize(initial_instant, final_instant, events)
    @initial_instant = initial_instant
    @final_instant = final_instant
    @events = events
    @current_instant = initial_instant
  end

  # Rodar simulador
  def run
    processor = Processor.new(self)

    # Enquanto o instante atual não é igual ao instante final, ele fica mandando jobs para o processador
    while @current_instant != @final_instant
      job = get_event_arrival_time(current_instant)

      unless event.nil?
        job = Job.new(event.priority, @current_instant, event)
        processor.submit_job(job)
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
