
=begin
Classe Queue
Descreve o comportamento da fila de jobs. Esta fila é aplicada no processador, na memória e nos dispositivos.
=end
class Queue

  ## Variáveis do Header da lista
  # w_max - Tempo máximo de espera
  # sum_tw - Tempo de espera acumulado
  # q_max - Máximo tamanho da fila
  # q - Tamanho atual da fila
  # sum_tq - tamanho * tempo acumulado
  # t_last - Instante da ultima entrada/saída
  # n - Contador de entrada
  # jobs - array de jobs da fila
  attr_accessor :w_max, :sum_tw, :q_max, :q, :sum_tq, :t_last, :n, :jobs

  def initialize
    @w_max = 100 # Definindo tempo máximo de espera
    @sum_tw = 0
    @q_max = 100 # Definindo tamanho máximo da fila arbitrário
    @q = 0
    @sum_tq = 0
    @t_last = 0
    @n = 0
    @jobs = []
  end


  # Função para adicionar job à fila
  def add_job(job, instant)
    # Caso a fila já esteja no seu tamanho máximo, ignorar chegada de um novo job (overflow de fila)
    if @q >= @q_max
      return
    end

    # Setando variáveis locais
    @q += 1 # Adicionando um item à fila
    @t_last = instant

    @jobs.push(job)
  end

  # Função para pegar job que chegou primeiro (First In First Out)
  def get_job(instant)
    # Caso esteja vazio, retorne nulo, não existe nenhum job na fila
    if @jobs.empty?
      return nil
    end

    # Setando variáveis locais
    @q -= 1 # Fila agora tem um elemento a menos
    @t_last = instant

    # Retorna o job que está na frente na fila
    @jobs.shift
  end

  # Verifica se a fila está vazia ou não
  def empty?
    @jobs.empty?
  end

  # A fila possui este determinado job?
  def has_job?(job)
    @jobs.each do |j|
      if j == job
        return true
      end
    end

    false
  end

end