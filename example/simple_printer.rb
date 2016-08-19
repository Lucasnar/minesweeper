class SimplePrinter

  def initialize
    @board_format = {
      unknown_cell: '.',
      clear_cell: ' ',
      bomb: '#',
      flag: 'F'
    }
  end

  def print_board(board)
    board.each do |x| 
      x.each do |y| 
        print @board_format[y] ? @board_format[y] : y
        print "\t"
      end
      puts
    end
    puts
  end

end
