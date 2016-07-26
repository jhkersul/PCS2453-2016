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
  ## Variáveis
  # simulation_log - Grava o log da simulação, tudo que está acontecendo nela
  # initial_instant - Instante inicial da simulação
  # final_instant - Instante final da simulação
  # current_instant - Instante atual da simulação
  # event_list - Lista de eventos
  # jobs_table - Tabela de Jobs
  attr_accessor :simulation_log, :initial_instant, :final_instant, :current_instant, :event_list, :jobs_table

  # IDs dos Dispositivos
  ID_DISK = 1
  ID_PRINTER1 = 2
  ID_PRINTER2 = 3
  ID_READER1 = 4
  ID_READER2 = 5

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
    processor = Processor.new(10)
    memory = MainMemory.new(1000, 10)
    disk = Device.new(1)
    printer1 = Device.new(3)
    printer2 = Device.new(3)
    reader1 = Device.new(1)
    reader2 = Device.new(1)


    # Formando lista inicial de eventos
    @event_list = EventList.new
    jobs_table.each do |job|
      event = Event.new(Event::ARRIVAL, job, job.arrival_time)
      @event_list.add(event)
    end


    while !@event_list.empty? && @current_instant < @final_instant
      current_event = @event_list.next
      @current_instant = current_event.event_time
      current_job = current_event.job

      case current_event.id
        when Event::ARRIVAL
          @event_list.add(Event.new(Event::REQUEST_CM, current_job, @current_instant))
          add_event_to_log(@current_instant, 'CHEGADA', current_job.name, 'JOB REQUISITA MEMÓRIA', 'EVENTO NOVO ADICIONADO NA LISTA')
        when Event::REQUEST_CM
          # Vamos tentar alocar na memória, se for possível já fazemos uma request pra CPU
          if memory.request(current_job, @current_instant)
            @event_list.add(Event.new(Event::REQUEST_CPU, current_job, @current_instant + memory.relocation_time))
            add_event_to_log(@current_instant, 'REQUERER MEMORIA', current_job.name, 'JOB REQUISITA CPU', 'EVENTO NOVO ADICIONADO NA LISTA')
          end

        when Event::REQUEST_CPU
          # Caso o job já tenha sido processado vamos liberar a CPU
          if current_job.done
            @event_list.add(Event.new(Event::RELEASE_CPU, current_job, @current_instant + processor.cpu_time))
            add_event_to_log(@current_instant, 'REQUERER CPU', current_job.name, 'JOB REQUISITA LIBERAÇÃO DA CPU POIS JÁ ESTÁ PRONTO', 'EVENTO NOVO ADICIONADO NA LISTA')

          # Caso o processador esteja ocupado, tenteremos executar no proximo tempo de execução
          elsif processor.busy
            @event_list.add(Event.new(Event::REQUEST_CPU, current_job, @current_instant + processor.cpu_time))
            add_event_to_log(@current_instant, 'REQUERER CPU', current_job.name, 'JOB REQUISITA CPU DEPOIS DE UM SLICE DE TEMPO, POIS ELA ESTÁ OCUPADA', 'EVENTO NOVO ADICIONADO NA LISTA')

          # Caso nenhum das acima seja verdadeira, vamos executar o job no processador
          else
            processor.request(current_job, @current_instant)
            @event_list.add(Event.new(Event::PROCESS_CPU, nil, @current_instant + processor.cpu_time))

            add_event_to_log(@current_instant, 'REQUERER CPU', current_job.name, 'SISTEMA ENVIA JOB PARA CPU PARA COMEÇAR A SER PROCESSADO', 'CPU COMEÇA A PROCESSAR JOB')
          end
        when Event::PROCESS_CPU
          job_executado = processor.run

          # Se o job já tiver sido executado, liberamos a CPU
          if job_executado.nil? || job_executado.done
            @event_list.add(Event.new(Event::RELEASE_CPU, job_executado, @current_instant + processor.cpu_time))

            add_event_to_log(@current_instant, 'PROCESSANDO JOB', job_executado.name, 'JOB JÁ TERMINOU DE EXECUTAR', 'CPU SERÁ LIBERADA')
          else
            # Caso o job ainda não tenha terminado, vamos voltar ele pra requerer CPU
            @event_list.add(Event.new(Event::REQUEST_CPU, job_executado, @current_instant + processor.cpu_time))

            add_event_to_log(@current_instant, 'PROCESSANDO JOB', job_executado.name, 'JOB AINDA NÃO ACABOU', 'ELE VAI VOLTAR PARA REQUISITAR A CPU NOVAMENTE')
          end

          # Checando se o processador ainda tem coisas pra executar
          if processor.busy
            @event_list.add(Event.new(Event::PROCESS_CPU, nil, @current_instant + processor.cpu_time))

            add_event_to_log(@current_instant, 'PROCESSANDO JOB', job_executado.name, 'PROCESSADOR AINDA TEM COISAS PRA EXECUTAR', 'VAMOS VOLTAR PARA O PROCESSAMENTO DO ROUND ROBIN')
          end

        when Event::RELEASE_CPU
          # Se o job ainda tem operações de IO para fazer, vamos criar um evento que realiza essas operações
          if current_job.has_io_operations
            @event_list.add(Event.new(Event::REQUEST_IO, current_job, @current_instant))
            add_event_to_log(@current_instant, 'LIBERAR CPU', current_job.name, 'JOB REQUISITA IO, POIS TEM INSTRUÇÕES IO PARA REALIZAR', 'EVENTO NOVO ADICIONADO NA LISTA')
          # Caso não tenhamos operações IO para realizar, o job já está completo, podemos liberar a memória
          else
            @event_list.add(Event.new(Event::RELEASE_CM, current_job, @current_instant))
            add_event_to_log(@current_instant, 'LIBERAR CPU', current_job.name, 'JOB ESTÁ COMPLETO, JÁ PODE LIBERAR A MEMÓRIA', 'EVENTO NOVO ADICIONADO NA LISTA')
          end

          # Se o processador tem algum job na fila, criamos um novo evento para processar esse job
          new_job = processor.release(current_job, @current_instant)

          unless new_job.nil?
            @event_list.add(Event.new(Event::REQUEST_CPU, new_job, @current_instant))
            add_event_to_log(@current_instant, 'LIBERAR CPU', new_job.name, 'CPU TEM JOBS NA FILA, VAMOS EXECUTÁ-LOS JÁ QUE AGORA ELA ESTÁ LIVRE', 'EVENTO NOVO ADICIONADO NA LISTA')
          end


        when Event::REQUEST_IO
          case current_job.device
            when ID_DISK
              used_device = disk
            when ID_PRINTER1
              used_device = printer1
            when ID_PRINTER2
              used_device = printer2
            when ID_READER1
              used_device = reader1
            when ID_READER2
              used_device = reader2
            else
              puts 'DISPOSITIVO INVALIDO'
              return
          end

          used_device.request(current_job, @current_instant)
          @event_list.add(Event.new(Event::RELEASE_IO, current_job, @current_instant + used_device.total_time))
          add_event_to_log(@current_instant, 'REQUERER IO', current_job.name, 'JOB É ENVIADO AO DISPOSITIVO', 'DISPOSITIVO PROCESSARÁ AS REQUISIÇÕES DE IO')

        when Event::RELEASE_IO
          case current_job.device
            when ID_DISK
              new_job = disk.release
            when ID_PRINTER1
              new_job = printer1.release
            when ID_PRINTER2
              new_job = printer2.release
            when ID_READER1
              new_job = reader1.release
            when ID_READER2
              new_job = reader2.release
            else
              puts 'DISPOSITIVO INVALIDO'
              return
          end

          # Vamos ver se o dispositivo possui outros jobs na fila
          unless new_job.nil?
            @event_list.add(Event.new(Event::REQUEST_IO, new_job, @current_instant))
            add_event_to_log(@current_instant, 'LIBERAR IO', new_job.name, 'EXISTE OUTROS JOBS NA FILA DO DISPOSITIVO', 'ENVIA REQUISIÇÃO AO DISPOSITIVO PARA PROCESSAR PROXIMO IO')
          end

          # Verificando se o job atual já terminou seus processos de IO, voltamos à CPU
          if current_job.io_operations == 0
            @event_list.add(Event.new(Event::REQUEST_CPU, current_job, @current_instant))
            add_event_to_log(@current_instant, 'LIBERAR IO', current_job.name, 'OPERAÇÃO IO ACABOU', 'ENVIA REQUISIÇÃO PARA CPU, AGORA SEM NENHUM IO PARA PROCESSAR')
          end

        when Event::RELEASE_CM
          # Liberamos a memória e adicionamos um evento de completion
          memory.release(current_job, @current_instant)
          @event_list.add(Event.new(Event::COMPLETION, current_job, @current_instant))
          add_event_to_log(@current_instant, 'LIBERAR MEMORIA', current_job.name, 'MEMÓRIA JÁ ESTÁ LIBERADA, EXECUÇÃO DO JOB FOI REALIZADA', 'EVENTO NOVO ADICIONADO NA LISTA')
        when Event::COMPLETION
          # Execução completada
          add_event_to_log(@current_instant, 'EXECUÇÃO JOB COMPLETA', current_job.name, '-', '-')
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
