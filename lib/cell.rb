class Cell
  attr_accessor :status, :value

  # Status will be:
  # 0 if hidden
  # 1 if hidden and has_flag
  # 2 if shown and clear
  # 3 if shown and has nearby mines
  # 4 if mine

  def initialize
    @status = 0
    @value = 0
    @was_clicked = false
    @has_flag = false
  end

  def click
    @was_clicked = true
    update_status
  end

  def flag_click
    @has_flag = !@has_flag
    update_status
  end

  def was_clicked?
    @was_clicked
  end

  def has_flag?
    @has_flag
  end

  def update_status
    if(has_flag?)
      @status = 1
    elsif(!was_clicked?)
      @status = 0
    elsif(@value == 0)
      @status = 2
    elsif(@value > 0)
      @status = 3
    else
      @status = 4
    end
  end
end

