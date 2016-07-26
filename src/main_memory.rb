require './block'

class MainMemory

  attr_accessor :mem_size, :relocation_time, :queue, :available_size, :blocks

  def initialize(mem_size, relocation_time)
    @queue = Queue.new
    @mem_size = mem_size
    @available_size = mem_size
    @relocation_time = relocation_time
    @blocks = []
  end

  # Retorna true quando job já foi alocado ou é alocado
  # Retorna false quando o job não pode ser alocado neste momento
  def request(job, time)

    # Verificando se este job já está na memória
    @blocks.each do |block|
      if block.name == job.name
        return true
      end
    end

    # Se na fila este job já existe, não podemos continuar processando pois este job ainda será processado
    if @queue.has_job?(job)
      return false
    end

    # Caso não tenhamos espaço, vamos colocar o job na fila
    if job.mem_size > @available_size
      @queue.add_job(job, time)
      return false
    end

    # Se temos espaço disponível, alocamos o bloco
    @available_size -= job.mem_size
    block = Block.new(job.name, 0, job.mem_size)
    @blocks << block

    true
  end

  def release(job, time)

    # Verificando se este job ocupa algum bloco
    @blocks.each do |block|
      if block.name == job.name
        @blocks.delete(block)
        @available_size -= job.mem_size
      end
    end

  end

  def has_job_queue?
    !@queue.empty?
  end


end