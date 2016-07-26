require './simulator'
require './device'
require './event'
require './event_list'

=begin
Classe Main
Responsável pelo início do programa
=end
class Main

  # Setando a codificação padrão do Ruby
  Encoding.default_internal = Encoding::UTF_8
  Encoding.default_external = Encoding::UTF_8

  # Começando programa
  puts "",
       "Projeto PCS2453 - Simulação de Autômatos",
       "João Henrique Kersul Faria - 8041157",
       ""

  puts "Digite o nome do arquivo .txt que deseja carregar (não precisa colocar a extensão):"

  # Pegando nome do arquivo do usuário
  file_name = "./test/" + gets.chomp + ".txt"

  # Se o arquivo existir, começamos a construir a lista de jobs
  if File.exist? file_name
    jobs_table = []

    # Abrindo e lendo arquivo
    file = File.open(file_name, "r")

    # Lendo linhas
    file.each_line do |line|
      # Criando um array com cada item da linha
      line_array = line.split(" ")
      # Jogando os valores que não são comentários para o job
      if line_array[0] != '#' && !line_array.nil?
        job = Job.new(line_array[0], line_array[1].to_i, line_array[2].to_i, line_array[3].to_i, line_array[4].to_i, line_array[5].to_i, line_array[6].to_i)

        jobs_table << job
      end
    end

    # Fechando arquivo
    file.close

    # Criando simulador
    simulator = Simulator.new(0, 100, jobs_table)
    # Rodando simulador
    simulator.run
  else
    puts "Arquivo não existe, finalizando programa."
  end

end
