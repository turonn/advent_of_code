class PieceOfRope
  attr_accessor :coord, :past_positions, :is_final_tail

  def initialize
    @coord = [0,0]
    @past_positions = [[0,0]]
    @is_final_tail = false
  end

  def move_head_one_space(direction)
    case direction
    when "U" then @coord[1] += 1
    when "D" then @coord[1] -= 1
    when "L" then @coord[0] -= 1
    when "R" then @coord[0] += 1
    else
      puts "error moving head #{direction}"
    end
  end

  def move_tail_if_needed(relative_head_coord)
    x_diff = _x_diff(relative_head_coord)
    y_diff = _y_diff(relative_head_coord)
    if x_diff > 1
      if y_diff > 0
        # move_tail_up_right
        @coord[0] += 1
        @coord[1] += 1
      elsif y_diff < 0
        # move_tail_down_right
        @coord[0] += 1
        @coord[1] -= 1
      else
        # move_tail_right
        @coord[0] += 1
      end
    elsif x_diff < -1
      if y_diff > 0
        # move_tail_up_left
        @coord[0] -= 1
        @coord[1] += 1
      elsif y_diff < 0
        # move_tail_down_left
        @coord[0] -= 1
        @coord[1] -= 1
      else
        # move_tail_left
        @coord[0] -= 1
      end
    elsif y_diff > 1
      if x_diff > 0
        # move_tail_up_right
        @coord[0] += 1
        @coord[1] += 1
      elsif x_diff < 0
        # move_tail_up_left
        @coord[0] -= 1
        @coord[1] += 1
      else
        # move_tail_up
        @coord[1] += 1
      end
    elsif y_diff < -1
      if x_diff > 0
        # move_tail_down_right
        @coord[0] += 1
        @coord[1] -= 1
      elsif x_diff < 0
        # move_tail_down_left
        @coord[0] -= 1
        @coord[1] -= 1
      else
        # move_tail_down
        @coord[1] -= 1
      end
    end

    _record_new_position_if_needed
  end

  def count_final_tail_unique_past_positions
    @past_positions.uniq.count
  end

  private

  def _x_diff(relative_head_coord)
    relative_head_coord[0] - @coord[0]
  end

  def _y_diff(relative_head_coord)
    relative_head_coord[1] - @coord[1]
  end

  def _record_new_position_if_needed
    return unless is_final_tail
    return unless [@coord[0],@coord[1]] != past_positions.last
    @past_positions << [@coord[0], @coord[1]]
  end
end

def read_file(file)
  directions = []
  f = File.open(file, "r")
  f.each_line do |line|
    directions << line.strip.split(' ')
  end

  directions
end

def move_pieces_of_rope(pieces_of_rope, direction)
  pieces_of_rope.each_with_index do |t, i|
    if i == 0
      t.move_head_one_space(direction)
      next
    end

    t.move_tail_if_needed(pieces_of_rope[i-1].coord)
  end
end

file='2022/day_9/input.txt'
directions = read_file(file)

pieces_of_rope = (1..10).map { |_| PieceOfRope.new }
pieces_of_rope.last.is_final_tail = true

directions.each do |direction|
  direction[1].to_i.times do
    move_pieces_of_rope(pieces_of_rope, direction[0])
  end
end

puts pieces_of_rope.last.count_final_tail_unique_past_positions