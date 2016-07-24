require '../part1/processor'

=begin
Classe Simulator
É o simulador em si, esta classe gerencia as execuções do simulador
=end
class Simulator
  attr_accessor :simulation_log, :initial_instant, :final_instant, :programs, :current_instant, :jobs_table

  # Carregando dados na inicialização do simulador
  def initialize(initial_instant, final_instant, programs)
    @initial_instant = initial_instant
    @final_instant = final_instant
    @programs = programs
    @current_instant = initial_instant
  end

  # Rodar simulador
  def run
    processor = Processor.new(self)

    while @current_instant != @final_instant
      processor.clock

      add_event_to_log(current_instant, "NADA", "NADA", "NADA", "NADA")
    end

    print_log
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
