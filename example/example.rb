require_relative("../lib/minesweeper")
require_relative('simple_printer')
require_relative('pretty_printer')

puts "==== Exemplo 1 (jogo aleatório) ===="

width, height, num_mines = 10, 20, 50
puts "Tabuleiro #{width} x #{height}"
puts "#{num_mines} minas"

game = Minesweeper.new(width, height, num_mines)

while game.still_playing?
  valid_move = game.play(rand(width), rand(height))
  valid_flag = game.flag(rand(width), rand(height))
  if valid_move or valid_flag
    printer = (rand > 0.5) ? SimplePrinter.new : PrettyPrinter.new
    printer.print_board(game.board_state)
  end
end

puts "Fim do jogo!"
if game.victory?
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  PrettyPrinter.new.print_board(game.board_state(xray: true))
end
puts

puts "==== Exemplo 2 (jogo com vitória, zero minas) ===="

width, height, num_mines = 8, 8, 0
puts "Tabuleiro #{width} x #{height}"
puts "#{num_mines} minas"

game = Minesweeper.new(width, height, num_mines)

game.play(rand(width), rand(height))
printer = PrettyPrinter.new
printer.print_board(game.board_state)

puts "Fim do jogo!"
puts "Você venceu!"
puts

puts "==== Exemplo 3 (jogo perdido, apenas minas) ===="

width, height, num_mines = 5, 5, 25
puts "Tabuleiro #{width} x #{height}"
puts "#{num_mines} minas"

game = Minesweeper.new(width, height, num_mines)

game.play(rand(width), rand(height))
printer = PrettyPrinter.new
printer.print_board(game.board_state)

puts "Fim do jogo!"
puts "Você perdeu! As minas eram:"
PrettyPrinter.new.print_board(game.board_state(xray: true))
puts

puts "==== Exemplo 4 (jogo aleatório, apenas simple printer) ===="

width, height, num_mines = rand(4..8), rand(4..8), rand(8..14)
puts "Tabuleiro #{width} x #{height}"
puts "#{num_mines} minas"

game = Minesweeper.new(width, height, num_mines)

while game.still_playing?
  valid_move = game.play(rand(width), rand(height))
  valid_flag = game.flag(rand(width), rand(height))
  if valid_move or valid_flag
    SimplePrinter.new.print_board(game.board_state)
  end
end

puts "Fim do jogo!"
puts "Você perdeu! As minas eram:"
SimplePrinter.new.print_board(game.board_state(xray: true))
