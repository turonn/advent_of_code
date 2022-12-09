class Map
  attr_accessor :head_position, :tail_position, :tail_visited_coords

  def initialize(head_position, tail_position)
    @head_position = head_position
    @tail_position = tail_position
    @tail_visited_coords = [tail_position[0], tail_position[1]]
  end

  def move_head_one_space(direction)
    case direction
    when "U" then @head_position[1] += 1
    when "D" then @head_position[1] -= 1
    when "L" then @head_position[0] -= 1
    when "R" then @head_position[0] += 1
    else
      puts "error moving head #{direction}"
    end
  end

  def move_tail_if_needed
    if _x_diff > 1
      if _y_diff > 0
        # move_tail_up_right
        @tail_position[0] += 1
        @tail_position[1] += 1
        _record_tail_position
      elsif _y_diff < 0
        # move_tail_down_right
        @tail_position[0] += 1
        @tail_position[1] -= 1
        _record_tail_position
      else
        # move_tail_right
        @tail_position[0] += 1
        _record_tail_position
      end
    elsif _x_diff < -1
      if _y_diff > 0
        # move_tail_up_left
        @tail_position[0] -= 1
        @tail_position[1] += 1
        _record_tail_position
      elsif _y_diff < 0
        # move_tail_down_left
        @tail_position[0] -= 1
        @tail_position[1] -= 1
        _record_tail_position
      else
        # move_tail_left
        @tail_position[0] -= 1
        _record_tail_position
      end
    elsif _y_diff > 1
      if _x_diff > 0
        # move_tail_up_right
        @tail_position[0] += 1
        @tail_position[1] += 1
        _record_tail_position
      elsif _x_diff < 0
        # move_tail_up_left
        @tail_position[0] -= 1
        @tail_position[1] += 1
        _record_tail_position
      else
        # move_tail_up
        @tail_position[1] += 1
        _record_tail_position
      end
    elsif _y_diff < -1
      if _x_diff > 0
        # move_tail_down_right
        @tail_position[0] += 1
        @tail_position[1] -= 1
        _record_tail_position
      elsif _x_diff < 0
        # move_tail_down_left
        @tail_position[0] -= 1
        @tail_position[1] -= 1
        _record_tail_position
      else
        # move_tail_down
        @tail_position[1] -= 1
        _record_tail_position
      end
    end
  end

  def count_tail_visited_coords
    @tail_visited_coords.uniq.count
  end

  private 

  # positve means _need_ to move right
  def _x_diff
    @head_position[0] - @tail_position[0]
  end

  def _y_diff
    @head_position[1] - @tail_position[1]
  end

  def _record_tail_position
    @tail_visited_coords << [@tail_position[0], @tail_position[1]]
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

file='2022/day_9/input.txt'
directions = read_file(file)
map = Map.new([0,0],[0,0])

directions.each do |direction|
  direction[1].to_i.times do
    map.move_head_one_space(direction[0])
    map.move_tail_if_needed
  end
end

puts map.count_tail_visited_coords