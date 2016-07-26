=begin
Classe Job
Descreve a estrutura de um job no sistema. Classe descritiva.
=end
class Job

  ## Variáveis
  # name - Nome do job
  # arrival_time - Instante que o job deve ser executado
  # total_time - Tempo total que este evento demora pra ser processado
  # mem_size - Memória necessária para executar
  # io_operations - Número de operações de io que realiza
  # priority - Prioridade do job, quanto maior, mais prioritário
  # device - dispostivo que será usado
  # t_needed - É usado a referência de quanto tempo o job precisa para terminar sua execução
  attr_accessor :name, :arrival_time, :total_time, :mem_size, :io_operations, :priority, :device, :t_needed

  # Inicializando valores iniciais do programa
  def initialize(name, arrival_time, total_time, mem_size, io_operations, priority, device)
    @name = name
    @arrival_time = arrival_time
    @total_time = total_time
    @mem_size = mem_size
    @io_operations = io_operations
    @priority = priority
    @device = device
    @t_needed = @total_time
  end

  # Diminui o tempo necessário para processar este job
  def decrease_time(time)
    if @t_needed > 0
      @t_needed -= time
    end
  end

  def done
    @t_needed <= 0
  end

  def has_io_operations
    @io_operations > 0
  end

end