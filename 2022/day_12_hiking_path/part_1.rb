class Map
  attr_accessor :width, :height, :starting_point, :ending_point
  def initialize(map, starting_point, ending_point)
    @map = map
    @width = map.first.count
    @height = map.count
    @starting_point = starting_point
    @ending_point = ending_point
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
    puts "right"
    puts perspective_point.tentitive_distance
  end

  def _look_left(point)
    perspective_point = @map[point.y_pos][point.x_pos - 1]
    return unless _can_travel?(point, perspective_point)
    perspective_point.tentitive_distance = point.tentitive_distance + 1
    puts "left"
    puts perspective_point.tentitive_distance
  end

  def _look_up(point)
    perspective_point = @map[point.y_pos - 1][point.x_pos]
    return unless _can_travel?(point, perspective_point)
    perspective_point.tentitive_distance = point.tentitive_distance + 1
    puts "up"
    puts perspective_point.tentitive_distance
  end

  def _look_down(point)
    perspective_point = @map[point.y_pos + 1][point.x_pos]
    return unless _can_travel?(point, perspective_point)
    perspective_point.tentitive_distance = point.tentitive_distance + 1
    puts "down"
    puts perspective_point.tentitive_distance
  end
end


class Point
  attr_accessor :tentitive_distance, :visited
  attr_reader :x_pos, :y_pos, :height

  def initialize(x_pos, y_pos, height, tentitive_distance = nil)
    @x_pos = x_pos
    @y_pos = y_pos
    @height = height
    @tentitive_distance = Float::INFINITY
    @visited = false
  end
end

def read_file(file)
  map = []
  starting_point = ending_point = nil
  y_pos = 0
  f = File.open(file, "r")
  f.each_line do |line|
    map << line.strip.split('').each_with_index.map do |p, x_pos|
      height =  if p == "S"
                  starting_point = Point.new(x_pos, y_pos, 1)
                  next starting_point
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

  Map.new(map, starting_point, ending_point)
end

def map_way_to_end(map)
  point = map.starting_point

  until map.ending_point.visited == true
    map.look_around(point)

    point = map.visit_next_shortest_path
  end

  map
end

use_input = true
file = use_input ? '2022/day_12/input.txt' : '2022/day_12/example.txt'
map = read_file(file)

puts map.starting_point.inspect
map = map_way_to_end(map)

puts map.ending_point.tentitive_distance