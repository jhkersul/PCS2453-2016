=begin
Classe Program
Responsável por definir o comportamento de um programa
=end
class Program

  attr_accessor :total_time, :mem_size, :io_operations, :type_io

  # Inicializando valores iniciais do programa
  def initialize(total_time, mem_size, io_operations, type_io)
    @total_time = total_time
    @mem_size = mem_size
    @io_operations = io_operations
    @type_io = type_io
  end

  # Tipos de entrada/saída suportadas
  @@IO_MEMORY_ACCESS = "memory"
  @@IO_DISK_ACCESS = "disk"
  @@IO_READER1_ACCESS = "reader1"
  @@IO_READER2_ACCESS = "reader2"
  @@IO_PRINTER1_ACCESS = "printer1"
  @@IO_PRINTER2_ACCESS = "printer2"

  def IO_MEMORY_ACCESS
    @@IO_MEMORY_ACCESS
  end
  def IO_DISK_ACCESS
    @@IO_DISK_ACCESS
  end
  def IO_READER1_ACCESS
    @@IO_READER1_ACCESS
  end
  def IO_READER2_ACCESS
    @@IO_READER2_ACCESS
  end
  def IO_PRINTER1_ACCESS
    @@IO_PRINTER1_ACCESS
  end
  def IO_PRINTER2_ACCESS
    @@IO_PRINTER2_ACCESS
  end

end