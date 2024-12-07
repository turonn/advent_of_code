class Point
  attr_reader :x_pos, :y_pos, :shape, :has_obstruction, :been_visited, :has_guard

  module Directions
    ALL = ["^", ">", "v", "<"].freeze
  end

  # @param x_pos [Integer]
  # @param y_pos [Integer]
  # @param shape [String] either '.' or '#'
  def initialize(x_pos, y_pos, shape)
    @x_pos = x_pos
    @y_pos = y_pos
    @shape = shape
    @has_obstruction = shape == '#'
    @been_visited = @has_guard = Directions::ALL.include?(shape)
  end

  # @param shape [String] '^' || '>' || 'v' || '<'
  def visit(shape)
    @shape = shape
    @been_visited = @has_guard = true
    self
  end

  def leave
    @shape = '.'
    @has_guard = false
  end

  def rotate_guard
    raise "no guard!" unless @has_guard
    @shape =  case @shape
              when "^" then ">"
              when ">" then "v"
              when "v" then "<"
              when "<" then "^"
              end
    self
  end
end

class Map
  # @param points [Array[Array[Point]]]
  def initialize(rows, starting_coordinates)
    @rows = rows
    @height = rows.count
    @width = rows.first.count
    @current_point = rows[starting_coordinates[1]][starting_coordinates[0]]
  end

  # @return [boolean] returns false if we have left the board
  def move_one(starting_point = @current_point)
    new_coordinates = case starting_point.shape
                      when "^" then [starting_point.x_pos,     starting_point.y_pos - 1]
                      when ">" then [starting_point.x_pos + 1, starting_point.y_pos    ]
                      when "v" then [starting_point.x_pos,     starting_point.y_pos + 1]
                      when "<" then [starting_point.x_pos - 1, starting_point.y_pos    ]
                      end
    return false if _off_map?(new_coordinates)
    new_point = @rows[new_coordinates[1]][new_coordinates[0]]
    
    return move_one(starting_point.rotate_guard) if new_point.has_obstruction
      
    @current_point = new_point.visit(starting_point.shape)
    starting_point.leave
    true
  end

  def count_visited_points
    count = 0
    @rows.each do |row|
      row.each do |point|
        count += 1 if point.been_visited
      end
    end

    count
  end

  private

  # @param coordinates [Array[Intiger]]
  # @return [Boolean]
  def _off_map?(coordinates)
    x = coordinates[0]
    y = coordinates[1]
    return true if x < 0
    return true if y < 0
    return true if x >= @width
    return true if y >= @height
    false
  end
end

rows = []
starting_coords = []

file = '2024/day_6_guard/input.txt'
f = File.open(file, "r")
f.each_line.with_index do |line, y_pos|
  row = []
  line.strip.split('').each_with_index do |shape, x_pos|
    starting_coords = [x_pos, y_pos] if Point::Directions::ALL.include?(shape)
    row << Point.new(x_pos, y_pos, shape)
  end
  rows << row
end

map = Map.new(rows, starting_coords)

while true
  break unless map.move_one
end

pp map.count_visited_points