
class Processor

  ## Variáveis do Header da lista
  # jobExecution - Job que está em execução
  # jobPreempting - Job que está antecipado, esperando a execução
  # priority - Prioridade do job em execução
  # nextT - Próximo instante de tempo para o job seguinte
  # currentT - Instante de tempo atual
  # interruptFlag - Flag de interrupção para o job atual
  attr_accessor :jobExecution, :jobPreempting, :priority, :nextT, :currentT, :interruptFlag, :queue

  @simulator

  def initialize(simulator)
    @simulator = simulator
    @queue = Queue.new
  end

  # Jobs entram por aqui
  def submit_job(job)
    # A CPU está ocupada?
    unless jobExecution.nil?
      # A prioridade do Job que está chegando é maior que o Job que está sendo executado?
      if job.priority > jobExecution.priority

      else
        # Caso a prioridade seja menor, adicionamos à fila do processador
        @queue.add_job(job)
      end
    end
  end

  def clock
    @simulator.current_instant += 1
  end



end