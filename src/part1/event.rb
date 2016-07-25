=begin
Classe Event
Responsável por definir o comportamento de um processo
=end
class Event

  attr_accessor :id, :job, :execution_time

  def initialize(id, job, execution_time)
    @id = id
    @job = job
    @execution_time = execution_time
  end

  @@id_iniciar = 1
  @@id_requerer_memoria= 2
  @@id_requerer_cpu = 3
  @@id_liberar_cpu = 4
  @@id_requerer_io = 5
  @@id_liberar_io = 6
  @@id_liberar_cpu_memoria = 7
  @@id_mudar_programa_cpu = 8
  @@id_mudar_segmento = 9

  def id_iniciar
    @@id_iniciar
  end
  def id_requerer_memoria
    @@id_requerer_memoria
  end
  def id_requerer_cpu
    @@id_requerer_cpu
  end
  def id_requerer_io
    @@id_requerer_io
  end
  def id_liberar_io
    @@id_liberar_io
  end
  def id_liberar_cpu
    @@id_liberar_cpu
  end
  def id_liberar_cpu_memoria
    @@id_liberar_cpu_memoria
  end
  def id_mudar_programa_cpu
    @@id_mudar_programa_cpu
  end
  def id_mudar_segmento
    @@id_mudar_segmento
  end

end