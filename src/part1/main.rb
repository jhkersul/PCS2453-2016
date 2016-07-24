require './simulator'

=begin
Classe Main
Responsável pelo início do programa
=end
class Main

  simulator = Simulator.new(0, 100, nil)

  simulator.run

end
