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

  @id_disk = 1
  @id_printer1 = 2
  @id_printer2 = 3
  @id_reader1 = 4
  @id_reader2 = 5

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
    processor = Processor.new(self, 10)
    memory = MainMemory.new(1000, 10)
    disk = Device.new(1)
    printer1 = Device.new(1)
    printer2 = Device.new(1)
    reader1 = Device.new(1)
    reader2 = Device.new(1)


    # Formando lista inicial de eventos
    @event_list = EventList.new
    jobs_table.each do |job|
      event = Event.new(Event.arrival, job, job.arrival_time)
      @event_list.add(event)
    end


    while !@event_list.empty? && @current_instant < @final_instant
      current_event = @event_list.next
      @current_instant = current_event.event_time
      current_job = current_event.job

      case current_event.id
        when Event.arrival
          @event_list.add(Event.new(Event.request_cm, current_job, @current_instant))
          add_event_to_log(@current_instant, 'CHEGADA', current_job.name, 'JOB REQUISITA MEMÓRIA', 'EVENTO NOVO ADICIONADO NA LISTA')
        when Event.request_cm
          # Vamos tentar alocar na memória, se for possível já fazemos uma request pra CPU
          if memory.request(current_job, @current_instant)
            @event_list.add(Event.new(Event.request_cpu, current_job, @current_instant + memory.relocation_time))
            add_event_to_log(@current_instant, 'REQUERER MEMORIA', current_job.name, 'JOB REQUISITA CPU', 'EVENTO NOVO ADICIONADO NA LISTA')
          end

        when Event.request_cpu
          # Caso o job já tenha sido processado vamos liberar a CPU
          if current_job.done
            @event_list.add(Event.new(Event.release_cpu, current_job, @current_instant))
            add_event_to_log(@current_instant, 'LIBERAR CPU', current_job.name, 'JOB REQUISITA LIBERAÇÃO DA CPU POIS JÁ ESTÁ PRONTO', 'EVENTO NOVO ADICIONADO NA LISTA')

          # Caso o processador esteja ocupado, tenteremos executar no proximo tempo de execução
          elsif processor.busy
            @event_list.add(Event.new(Event.request_cpu, current_job, @current_instant + processor.cpu_time))
            add_event_to_log(@current_instant, 'REQUERER CPU', current_job.name, 'JOB REQUISITA CPU DEPOIS DE UM SLICE DE TEMPO, POIS ELA ESTÁ OCUPADA', 'EVENTO NOVO ADICIONADO NA LISTA')

          # Caso nenhum das acima seja verdadeira, vamos executar o job no processador
          else
            processor.submit_job(current_job)
            add_event_to_log(@current_instant, 'EXECUTAR JOB', current_job.name, 'SISTEMA ENVIA JOB PARA CPU PARA COMEÇAR A SER PROCESSADO', 'CPU COMEÇA A PROCESSAR JOB')
          end
        when Event.release_cpu
          # Se o job ainda tem operações de IO para fazer, vamos criar um evento que realiza essas operações
          if current_job.has_io_operations
            @event_list.add(Event.new(Event.request_io, current_job, @current_instant))
            add_event_to_log(@current_instant, 'REQUISIÇÃO DE IO', current_job.name, 'JOB REQUISITA IO, POIS TEM INSTRUÇÕES IO PARA REALIZAR', 'EVENTO NOVO ADICIONADO NA LISTA')
          # Caso não tenhamos operações IO para realizar, o job já está completo, podemos liberar a memória
          else
            @event_list.add(Event.new(Event.release_cm, current_job, @current_instant))
            add_event_to_log(@current_instant, 'LIBERA MEMÓRIA', current_job.name, 'JOB ESTÁ COMPLETO, JÁ PODE LIBERAR A MEMÓRIA', 'EVENTO NOVO ADICIONADO NA LISTA')
          end

          # Se o processador tem algum job na fila, criamos um novo evento para processar esse job
          if processor.has_job_queue
            new_job = processor.queue.next
            @event_list.add(Event.new(Event.request_cpu, new_job, @current_instant))
            add_event_to_log(@current_instant, 'REQUERER CPU', new_job.name, 'CPU TEM JOBS NA FILA, VAMOS EXECUTÁ-LOS JÁ QUE AGORA ELA ESTÁ LIVRE', 'EVENTO NOVO ADICIONADO NA LISTA')
          end

          processor.release(current_job, @current_instant)

        when Event.request_io
          case current_job.device
            when @id_disk
            when @id_printer1
            when @id_printer2
            when @id_reader1
            when @id_reader2
            else
              puts 'DISPOSITIVO INVALIDO'
          end

        when Event.release_io
          case current_job.device
            when @id_disk
            when @id_printer1
            when @id_printer2
            when @id_reader1
            when @id_reader2
            else
              puts 'DISPOSITIVO INVALIDO'
          end

        when Event.release_cm
          # Liberamos a memória e adicionamos um evento de completion
          memory.release(current_job, @current_instant)
          @event_list.add(Event.new(Event.completion, current_job, @current_instant))
          add_event_to_log(@current_instant, 'COMPLETAR EXECUÇÃO', new_job.name, 'MEMÓRIA JÁ ESTÁ LIBERADA, EXECUÇÃO DO JOB FOI REALIZADA', 'EVENTO NOVO ADICIONADO NA LISTA')
        when Event.completion
          # Execução completada
          add_event_to_log(@current_instant, 'FIM DO JOB', new_job.name, '-', '-')
        else
          puts 'ESTADO PROIBIDO'
      end

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
