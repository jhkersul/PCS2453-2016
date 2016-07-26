=begin
Classe Device
Descreve o funcionamento de um dispositivo do sistema
=end
class Device

  ## Variáveis
  # queue - Fila do dispositivo
  # time_per_io - Tempo que demora para cada operação de IO
  # total_time - Tempo calculado que iria demorar para realizar todas as operações de IO
  # busy - Sinal que indica se device está ocupado ou não
  attr_accessor :queue, :time_per_io, :total_time, :busy

  def initialize(time_per_io)
    @queue = Queue.new
    @time_per_io = time_per_io
    @busy = false
  end

  # Realizar request do dispositivo, fazendo-o executar uma operação de IO do job
  def request(job, time)
    # Se o dispositivo estiver ocupado, adicionar à fila
    if @busy
      @queue.add_job(job, time)
    # Se não estiver ocupado, nós executamos esta operação de IO
    else
      @busy = true
      @total_time = @time_per_io * job.io_operations
      job.io_operations = 0
    end
  end

  # Esta função libera o dispositivo para próxima operação de IO
  def release
    @busy = false
    if @queue.empty?
      nil
    else
      @queue.next
    end
  end



end