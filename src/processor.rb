require './queue'
require './simulator'
require './job'
require './round_robin'

class Processor

  ## Variáveis do Header da lista
  # job_execution - Job que está em execução
  # priority - Prioridade do job em execução
  # next_t - Próximo instante de tempo para o job seguinte
  # interrupt_flag - Flag de interrupção para o job atual
  attr_accessor :job_execution, :priority, :next_t, :current_t, :interrupt_flag, :queue, :simulator, :cpu_time, :round_robin

  def initialize(simulator, cpu_time)
    @simulator = simulator
    @cpu_time = cpu_time
    @queue = Queue.new
    @round_robin = RoundRobin.new(5)
  end

  def request(job, time)

    # Se for possível adicionar no Round Robin, colocaremos, se não for possível colocamos na fila do processador
    if @round_robin.add(job)
      true
    else
      @queue.add_job(job, time)
      false
    end

  end

  def release(job, time)
    # Removemos o job do Round Robin
    @round_robin.remove(job)

    # Se tiver algum job na fila de espera ele retorna este job
    if @queue.empty?
      nil
    else
      @queue.next
    end
  end

  def busy
    !@round_robin.is_empty?
  end

  # Executa um time slice
  def run
    # Executando job
    job = @round_robin.next
    job.decrease_time(@cpu_time)

    # Retornando job
    job
  end

  def has_job_queue
    !@queue.empty?
  end



end