
class MainMemory

  attr_accessor :mem_size, :relocation_time, :queue, :available_size, :blocks

  def initialize(mem_size, relocation_time)
    @queue = Queue.new
    @mem_size = mem_size
    @available_size = mem_size
    @relocation_time = relocation_time
    @blocks = []
  end

  def request(job, time)

    # Verificar se o segmento já está alocado na memória
    @blocks.each do |block|
      if block.name == job.name
        if
      end
    end
  end

end