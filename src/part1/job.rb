
class Job

  ## Variáveis
  # total_time - Tempo total que este evento demora pra ser processado
  # mem_size - Memória necessária para executar
  # io_operations - Número de operações de io que realiza
  # device - dispostivo que será usado
  attr_accessor :name, :arrival_time, :total_time, :mem_size, :io_operations, :priority, :device, :t_needed

  # Inicializando valores iniciais do programa
  def initialize(name, arrival_time, total_time, mem_size, num_segments, io_operations, priority, device)
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
  def decrease_time
    if @t_needed > 0
      @t_needed -= 1
    end
  end

end