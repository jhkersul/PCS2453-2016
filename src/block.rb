=begin
Classe Block
Descreve o comportamento do bloco de memória
=end
class Block

  ## Variáveis
  # name - Nome para o bloco (tem o mesmo nome do job)
  # segmento - Segmento do job
  # size - Tamanho deste bloco
  attr_accessor :name, :segment, :size

  def initialize(name, segment, size)
    @name = name
    @segment = segment
    @size = size
  end

end