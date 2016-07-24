
class Job

  ## Variáveis
  # priority - Prioridade deste job
  # tIn - Momento de entrada na fila
  # type - Tipo de operação que será realizada
  attr_accessor :priority, :tIn, :resource

  def initialize(priority, t_in, resource)
    @priority = priority
    @tIn = t_in
    @resource = resource
  end

end