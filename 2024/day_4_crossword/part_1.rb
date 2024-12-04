class Board
  def initialize(rows)
    @board = rows
    @height = rows.count
    @width = rows.first.count
  end

  # check each position for a "starting letter" and then check each starting letter
  # to see how many words we can make off of it
  def count(word)
    @count = 0

    @board.each_with_index do |row, y|
      row.each_with_index do |letter, x|
        next unless letter == word[0] # is starting letter?
        _check("right",       x + 1,  y,      word, 1)
        _check("left",        x - 1,  y,      word, 1)
        _check("up",          x,      y - 1,  word, 1)
        _check("down",        x,      y + 1,  word, 1)
        _check("up_right",    x + 1,  y - 1,  word, 1)
        _check("up_left",     x - 1,  y - 1,  word, 1)
        _check("down_left",   x - 1,  y + 1,  word, 1)
        _check("down_right",  x + 1,  y + 1,  word, 1)
      end
    end

    @count
  end

  private

  def _check(direction, x, y, word, index)
    if index >= word.size
      @count += 1
      return
    end

    return if _off_the_board(x, y)
    return unless word[index] == @board[y][x]

    case direction
    when "right"      then _check("right",      x + 1,  y,      word, index + 1)
    when "left"       then _check("left",       x - 1,  y,      word, index + 1)
    when "up"         then _check("up",         x,      y - 1,  word, index + 1)
    when "down"       then _check("down",       x,      y + 1,  word, index + 1)
    when "up_right"   then _check("up_right",   x + 1,  y - 1,  word, index + 1)
    when "up_left"    then _check("up_left",    x - 1,  y - 1,  word, index + 1)
    when "down_left"  then _check("down_left",  x - 1,  y + 1,  word, index + 1)
    when "down_right" then _check("down_right", x + 1,  y + 1,  word, index + 1)
    else
      pp "error -- #{direction}"
    end
  end

  def _off_the_board(x, y)
    return true if x < 0
    return true if y < 0
    return true if x >= @width
    return true if y >= @height
    false
  end
end


file = '2024/day_4/input.txt'

rows = []

f = File.open(file, "r")
f.each_line do |line|
  rows << line.strip.split('')
end

board = Board.new(rows)

pp board.count('XMAS')