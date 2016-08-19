class Minesweeper
  require_relative('cell')

  def initialize(width = 10, height = 20, num_mines = 50)
    raise ArgumentError, 
      "Number of mines higher than the number of cells." unless num_mines <= width * height

    @width, @height, @num_mines = width, height, num_mines
    @still_playing, @victory = true, false
    @num_revealed_cells = 0

    generate_board
  end

  def play(x, y)
    cur_cell = @board[x][y]
    if(is_click_valid?(cur_cell))
      cur_cell.click
      increment_revealed_cells

      if(cur_cell.value == -1)
        @still_playing = false
      elsif(cur_cell.value == 0)
        spread_from(x, y)
      end

      return true
    end
    false
  end

  def flag(x, y)
    cur_cell = @board[x][y]
    if(is_flag_click_valid?(cur_cell))
      cur_cell.flag_click
      return true
    end
    false
  end

  def board_state(xray: false)
    #current_board = @board
    cur_board = Marshal.load(Marshal.dump(@board))
    (0..@width-1).each do |x|
      (0..@height-1).each do |y|
        status = @board[x][y].status
        if(!xray || still_playing? || @board[x][y].value != -1)
          cur_board[x][y] = status == 3 ? @board[x][y].value : assign_status(status)
        else
          cur_board[x][y] = :bomb
        end
      end
    end
    cur_board
  end

  def still_playing?
    @still_playing
  end

  def victory?
    @victory
  end

  private

  def generate_board
    #puts @width.to_s + " x " + @height.to_s + " board"
    @board = Array.new(@width) { Array.new(@height) {Cell.new} }
    place_mines
  end

  def place_mines
    cur_num_mines = 0
    while(cur_num_mines != @num_mines)
      x = rand(@width)
      y = rand(@height)
      cell = @board[x][y]
      if(cell.value != -1)
        cell.value = -1
        update_nearby_cells(x, y)
        cur_num_mines += 1
      end
    end
  end

  def update_nearby_cells(x, y)
    (x-1..x+1).each do |cur_x|
      (y-1..y+1).each do |cur_y|
        if (within_borders?(cur_x, cur_y) && @board[cur_x][cur_y].value != -1 )
          @board[cur_x][cur_y].value += 1
        end
      end
    end
  end

  def is_click_valid?(cell)
    !cell.was_clicked? && !cell.has_flag? && still_playing?
  end

  def is_flag_click_valid?(cell)
    !cell.was_clicked? && still_playing?
  end

  def within_borders?(x, y)
    x >= 0 && y >= 0 && x < @width && y < @height
  end

  def spread_from(x, y)
    cells = []
    cells.push([x,y])
    while(!cells.empty?)
      cell = cells.shift
      x, y = cell[0], cell[1]
      cell = @board[cell[0]][cell[1]] 
      if (cell.value == 0)
        (x-1..x+1).each do |cur_x|
          (y-1..y+1).each do |cur_y|
            if (within_borders?(cur_x, cur_y) && is_click_valid?(@board[cur_x][cur_y]))
              cells.push([cur_x, cur_y])
              @board[cur_x][cur_y].click
              increment_revealed_cells
            end
          end
        end
      elsif(cell.value >= 0)
        cell.click
      end
    end
  end

  def assign_status(status)
    if (status == 0)
      :unknown_cell
    elsif (status == 1)
      :flag
    elsif (status == 2)
      :clear_cell
    elsif (status == 4)
      :bomb
    end
  end

  def increment_revealed_cells
    @num_revealed_cells += 1
    if(@num_revealed_cells == @width * @height - @num_mines)
      @still_playing = false
      @victory = true
    end
  end
end
