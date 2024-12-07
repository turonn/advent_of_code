class Point
  attr_reader :x_pos, :y_pos, :shape, :been_visited, :first_point, :first_pass_shape

  module Directions
    ALL = Set.new(["^", ">", "v", "<"]).freeze
  end

  module ObstructionShapes
    ALL = Set.new(["#", "O"]).freeze
  end

  # @param x_pos [Integer]
  # @param y_pos [Integer]
  # @param shape [String] either '.' or '#'
  def initialize(x_pos, y_pos, shape)
    @x_pos = x_pos
    @y_pos = y_pos
    @shape = shape
    @been_visited = @first_point = Directions::ALL.include?(shape)
    @first_pass_shape = nil
  end

  def has_obstruction?
    ObstructionShapes::ALL.include?(@shape)
  end

  # @param shape [String] '^' || '>' || 'v' || '<'
  def visit(shape)
    @shape = shape
    @been_visited = true
    @first_pass_shape ||= shape # can only put obstruction
    self
  end

  def leave
    @shape = '.'
  end

  def rotate_guard
    raise "no guard!" unless _has_guard?
    @shape =  case @shape
              when "^" then ">"
              when ">" then "v"
              when "v" then "<"
              when "<" then "^"
              end
    self
  end

  def set_shape(shape)
    @shape = shape
    self
  end

  def matches?(coordinates, shape)
    return false unless @shape == shape
    return false unless coordinates[0] == @x_pos
    return false unless coordinates[1] == @y_pos
    true
  end

  private

  def _has_guard?
    Directions::ALL.include?(@shape)
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

  # @return [Point, nil] returns nil if off the board
  def move_one(starting_point = @current_point)
    loop do
      new_coordinates = case starting_point.shape
                        when "^" then [starting_point.x_pos,     starting_point.y_pos - 1]
                        when ">" then [starting_point.x_pos + 1, starting_point.y_pos    ]
                        when "v" then [starting_point.x_pos,     starting_point.y_pos + 1]
                        when "<" then [starting_point.x_pos - 1, starting_point.y_pos    ]
                        end
  
      return nil if _off_map?(new_coordinates)
  
      new_point = @rows[new_coordinates[1]][new_coordinates[0]]
  
      if new_point.has_obstruction?
        starting_point.rotate_guard
        next # Restart the loop with the rotated guard
      end
  
      @current_point = new_point.visit(starting_point.shape)
      starting_point.leave
      return @current_point
    end
  end

  # @return [Array[Array[Integer]]]
  def possible_obstruction_coordinates
    @rows.flat_map do |row| 
      row.select(&:been_visited).map { |point| [point.x_pos, point.y_pos] }
    end
  end

  def creates_infinate_loop?(coord)
    obstruction_point = @rows[coord[1]][coord[0]]
    return false if obstruction_point.first_point
    obstruction_point.set_shape('O')

    starting_coordinates = _obstruction_starting_coords(obstruction_point)
    starting_shape = obstruction_point.first_pass_shape
    starting_point = @rows[starting_coordinates[1]][starting_coordinates[0]]
    @current_point = starting_point.set_shape(starting_shape)

    # we can make infinate loops that smaller than the whole path!
    visited_locations = Set.new([[@current_point.x_pos, @current_point.y_pos, @current_point.shape]])

    creates_loop = false

    creates_loop =  while true
                      new_point = move_one
                      break false if new_point.nil?

                      location = [new_point.x_pos, new_point.y_pos, new_point.shape]
                      break true if visited_locations.include?(location)
                      visited_locations << location
                    end

    obstruction_point.set_shape('.')
    @current_point.set_shape('.')

    creates_loop
  end

  private

  # @return [Array[Integer]]
  def _obstruction_starting_coords(obstruction_point)
    case obstruction_point.first_pass_shape
    when "^" then [obstruction_point.x_pos,     obstruction_point.y_pos + 1 ]
    when ">" then [obstruction_point.x_pos - 1, obstruction_point.y_pos     ]
    when "v" then [obstruction_point.x_pos,     obstruction_point.y_pos - 1 ]
    when "<" then [obstruction_point.x_pos + 1, obstruction_point.y_pos     ]
    end
  end

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

# at this point the map has been marked with all possible obstruction points
# check each point to see if an infanate loop can be made.

count = 0
map.possible_obstruction_coordinates.each do |coord|
  count += 1 if map.creates_infinate_loop?(coord)
end

pp count
