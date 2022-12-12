class Map
  attr_reader :width, :height, :ending_point, :map
  attr_accessor :shortest_number_of_steps

  def initialize(map, ending_point)
    @map = map
    @width = map.first.count
    @height = map.count
    @ending_point = ending_point
    @shortest_number_of_steps = Float::INFINITY
  end

  def reset_map 
    @map.flatten.each do |point|
      point.tentitive_distance = Float::INFINITY
      point.visited = false
    end
  end
  
  def possible_starting_points
    @map.flatten.select do |point|
      point.height == 1 && _next_to_a_b(point)
    end
  end

  def visit_next_shortest_path
    point = @map.flatten.select {|point| point.visited == false }.min_by(&:tentitive_distance)
    point.visited = true
    point
  end

  def look_around(point)
    _look_right(point) unless at_right_wall(point)
    _look_left(point) unless at_left_wall(point)
    _look_up(point) unless at_top(point)
    _look_down(point) unless at_bottom(point)
  end

  def at_right_wall(point)
    point.x_pos == @width - 1
  end

  def at_left_wall(point)
    point.x_pos == 0
  end

  def at_top(point)
    point.y_pos == 0
  end

  def at_bottom(point)
    point.y_pos == @height - 1
  end

  private

  def _next_to_a_b(point)
    _right_b(point) || _left_b(point) || _up_b(point) || _down_b(point)
  end

  def _right_b(point)
    return false if at_right_wall(point)
    @map[point.y_pos][point.x_pos + 1].height == 2
  end

  def _left_b(point)
    return false if at_left_wall(point)
    @map[point.y_pos][point.x_pos - 1].height == 2
  end

  def _up_b(point)
    return false if at_top(point)
    @map[point.y_pos - 1][point.x_pos].height == 2
  end

  def _down_b(point)
    return false if at_bottom(point)
    @map[point.y_pos + 1][point.x_pos].height == 2
  end

  def _can_travel?(current_point, perspective_point)
    return false if perspective_point.visited == true
    return true if current_point.height == perspective_point.height - 1
    return true if current_point.height >= perspective_point.height
    false
  end

  def _look_right(point)
    perspective_point = @map[point.y_pos][point.x_pos + 1]
    return unless _can_travel?(point, perspective_point)
    perspective_point.tentitive_distance = point.tentitive_distance + 1
  end

  def _look_left(point)
    perspective_point = @map[point.y_pos][point.x_pos - 1]
    return unless _can_travel?(point, perspective_point)
    perspective_point.tentitive_distance = point.tentitive_distance + 1
  end

  def _look_up(point)
    perspective_point = @map[point.y_pos - 1][point.x_pos]
    return unless _can_travel?(point, perspective_point)
    perspective_point.tentitive_distance = point.tentitive_distance + 1
  end

  def _look_down(point)
    perspective_point = @map[point.y_pos + 1][point.x_pos]
    return unless _can_travel?(point, perspective_point)
    perspective_point.tentitive_distance = point.tentitive_distance + 1
  end
end


class Point
  attr_accessor :tentitive_distance, :visited, :possible_starting_point
  attr_reader :x_pos, :y_pos, :height

  def initialize(x_pos, y_pos, height, tentitive_distance = nil)
    @x_pos = x_pos
    @y_pos = y_pos
    @height = height
    @tentitive_distance = Float::INFINITY
    @visited = false
    @possible_starting_point = height == 1
  end

  def set_as_starting_point
    @tentitive_distance = 0
    @visited = true
  end
end

def read_file(file)
  map = []
  ending_point = nil
  y_pos = 0
  f = File.open(file, "r")
  f.each_line do |line|
    map << line.strip.split('').each_with_index.map do |p, x_pos|
      height =  if p == "S"
                  1
                elsif p == "E"
                  ending_point = Point.new(x_pos, y_pos, 26)
                  next ending_point
                else
                  p.ord - 96
                end

      Point.new(x_pos, y_pos, height)
    end

  y_pos += 1
  end

  Map.new(map, ending_point)
end

def map_way_to_end(map, point)
  point.set_as_starting_point

  until map.ending_point.visited == true
    map.look_around(point)

    point = map.visit_next_shortest_path
  end

  map
end

use_input = true
file = use_input ? '2022/day_12/input.txt' : '2022/day_12/example.txt'
map = read_file(file)


puts map.possible_starting_points.count
map.possible_starting_points.each do |point|
  next unless point.possible_starting_point
  puts point.inspect
  map_way_to_end(map, point)

  if map.ending_point.tentitive_distance < map.shortest_number_of_steps
    map.shortest_number_of_steps = map.ending_point.tentitive_distance
  end

  map.reset_map
end

puts map.shortest_number_of_steps