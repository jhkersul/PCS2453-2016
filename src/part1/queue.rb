
class Queue

  ## Variáveis do Header da lista
  # ptr - Apontador para o tipo da lista
  # wMax - Tempo máximo de espera
  # sumTw - Tempo de espera acumulado
  # qMax - Máximo tamanho da fila
  # q - Tamanho atual da fila
  # sumTq - tamanho * tempo acumulado
  # tLast - Instante da ultima entrada/saída
  # n - Contador de entrada
  # resource - Recurso a qual essa fila pertence
  attr_accessor :ptr, :wMax, :sumTw, :qMax, :q, :sumTq, :tLast, :n, :resource


  def add_job(job)

  end

end