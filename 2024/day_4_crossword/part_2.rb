class Board
  def initialize(rows)
    @board = rows
    @height = rows.count
    @width = rows.first.count
  end

  # check each position for a "starting letter" and then check each starting letter
  # to see how many words we can make off of it
  def count(word)
    @center_letter_positions = [] # will be arry of coordinates

    @board.each_with_index do |row, y|
      row.each_with_index do |letter, x|
        next unless letter == word[0] # is starting letter?
        _check("up_right",    x + 1,  y - 1,  word, 1, [x + 1,  y - 1])
        _check("up_left",     x - 1,  y - 1,  word, 1, [x - 1,  y - 1])
        _check("down_left",   x - 1,  y + 1,  word, 1, [x - 1,  y + 1])
        _check("down_right",  x + 1,  y + 1,  word, 1, [x + 1,  y + 1])
      end
    end

    @center_letter_positions.count - @center_letter_positions.uniq.count
  end

  private

  def _check(direction, x, y, word, index, center_letter_position)
    if index >= word.size
      @center_letter_positions << center_letter_position
      return
    end

    return if _off_the_board(x, y)
    return unless word[index] == @board[y][x]

    case direction
    when "up_right"   then _check("up_right",   x + 1,  y - 1,  word, index + 1, center_letter_position)
    when "up_left"    then _check("up_left",    x - 1,  y - 1,  word, index + 1, center_letter_position)
    when "down_left"  then _check("down_left",  x - 1,  y + 1,  word, index + 1, center_letter_position)
    when "down_right" then _check("down_right", x + 1,  y + 1,  word, index + 1, center_letter_position)
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


file = '2024/day_4_crossword/input.txt'

rows = []

f = File.open(file, "r")
f.each_line do |line|
  rows << line.strip.split('')
end

board = Board.new(rows)

pp board.count('MAS')