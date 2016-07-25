require './queue'
require './simulator'
require './job'

class Processor

  ## Variáveis do Header da lista
  # job_execution - Job que está em execução
  # priority - Prioridade do job em execução
  # next_t - Próximo instante de tempo para o job seguinte
  # interrupt_flag - Flag de interrupção para o job atual
  attr_accessor :job_execution, :priority, :next_t, :current_t, :interrupt_flag, :queue, :simulator, :cpu_time

  def initialize(simulator, cpu_time)
    @simulator = simulator
    @cpu_time = cpu_time
    @queue = Queue.new
  end

  def submit_job(job)
    @simulator.add_event_to_log(@current_t, "NOVO JOB CHEGANDO", job.event.name, "JOB SERÁ ADICIONADO NA FILA", "JOB ESTÁ NA FILA DO PROCESSADOR")
    @queue.add_job(job, @current_t)
  end

  # Esta função submete jobs no sistema de round robin, ele usa o sistema de fila usando FIFO (First In First Out)
  def round_robin
    # Se a fila estiver vazia, não temos nada para processar, logo, não adianta utilizarmos o round-robin
    if @queue.empty?
      execute_job(nil)
      return
    end

    # Pegando job da fila
    job = @queue.get_job(@current_t)

    # Executando job
    execute_job(job)
  end


  # Jobs entram por aqui
  def execute_job(job)
    # Se está vindo um job nulo e job que está em execução ainda não terminou, podemos continuar execuntando-o
    if job.nil? && !@job_execution.nil?
      # Diminui um ciclo de execução do job
      @job_execution.decrease_time
      @simulator.add_event_to_log(@current_t, "JOB EXECUTANDO", @job_execution.event.name, "JOB EXECUTOU UM CICLO", "DIMINUI UMA UNIDADE DO TEMPO NECESSÁRIO NO JOB")

      # Se terminamos de processar o job, podemos colocar o processador como livre
      if @job_execution.t_needed == 0
        @simulator.add_event_to_log(@current_t, "JOB TERMINOU", @job_execution.event.name, "LIMPA JOB_EXECUTION DO PROCESSADOR", "PROCESSADOR PRONTO PARA RECEBER JOB")
        @job_execution = nil
      end

      return
    elsif job.nil? && @job_execution.nil?
      # Se não temos nada pra executar, não fazemos nada
      return
    end

    # A CPU está ocupada?
    if !@job_execution.nil?
      # A prioridade do Job que está chegando é maior que o Job que está sendo executado?
      if job.priority > @job_execution.priority
        @simulator.add_event_to_log(@current_t, "JOB COM PRIORIDADE MAIOR", job.event.name, "JOB SERÁ PREPARADO PARA EXECUÇÃO", "JOB QUE ESTAVA EM EXECUÇÃO IRÁ PARA FILA")

        # Se a prioridade é maior, vamos executar
        @queue.add_job(@job_execution, @current_t)
        set_job_execution(job)
      else
        # Caso a prioridade seja menor, adicionamos à fila do processador
        @queue.add_job(job, @current_t)
        @simulator.add_event_to_log(@current_t, "JOB COM PRIORIDADE MENOR", job.event.name, "JOB VAI PARA FILA", "JOB ARMAZENADO NA FILA")
      end

      # Diminui um ciclo de execução do job
      @job_execution.decrease_time
      @simulator.add_event_to_log(@current_t, "JOB EXECUTANDO", @job_execution.event.name, "JOB EXECUTOU UM CICLO", "DIMINUI UMA UNIDADE DO TEMPO NECESSÁRIO NO JOB")

      # Se terminamos de processar o job, podemos colocar o processador como livre
      if @job_execution.t_needed == 0
        @job_execution = nil
        @simulator.add_event_to_log(@current_t, "JOB TERMINOU", job.event.name, "LIMPA JOB_EXECUTION DO PROCESSADOR", "PROCESSADOR PRONTO PARA RECEBER JOB")
      end

    else
      # Se a CPU não está ocupada, é só colocar um job novo para ela
      set_job_execution(job)
    end
  end

  def release(job, time)

  end

  def busy
    !@job_execution.nil?
  end

  def set_job_execution(job)
    # Setando novo job para ser executado
    @job_execution = job
    @next_t = @current_t + @job_execution.t_needed

    # Adicionando no log
    @simulator.add_event_to_log(@current_t, "NOVO JOB NO PROCESSADOR", job.event.name, "JOB ENTRA NO PROCESSADOR", "JOB COMEÇARÁ A EXECUÇÃO")
  end

  def clock
    @simulator.current_instant += 1
    @current_t = @simulator.current_instant

    # Roda o round_robin em cada ciclo de clock
    round_robin
  end

  def has_job_queue
    !@queue.empty?
  end



end