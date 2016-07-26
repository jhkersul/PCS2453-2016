require './block'

=begin
Classe MainMemory
Descreve o comportamento da memória principal do sistema
=end
class MainMemory

  ## Variáveis
  # mem_size - Tamanho da memória
  # relocation_time - Tempo de relocação da memória
  # queue - Fila da memória
  # available_size - Espaço disponível na memória
  # blocks - Blocos na memória
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

  # Função que libera job da memória
  def release(job, time)

    # Verificando se este job ocupa algum bloco
    @blocks.each do |block|
      if block.name == job.name
        @blocks.delete(block)
        @available_size -= job.mem_size
      end
    end

  end

  # Função que verifica se existe algum job na fila da memória
  def has_job_queue?
    !@queue.empty?
  end


end