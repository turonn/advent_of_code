# frozen_string_literal: true

class Point
  attr_reader :x, :y
  attr_accessor :shape

  def initialize(x,y,shape)
    @x = x
    @y = y
    @shape = shape
  end

  def has_robot?
    @shape == '@'
  end

  def has_box?
    @shape == 'O'
  end

  def is_empty?
    @shape == '.'
  end

  def is_wall?
    @shape == '#'
  end

  def gps_score
    return 0 unless has_box?
    @y * 100 + @x
  end
end

class Map
  module Directions
    ALL = [LEFT = '<', RIGHT = '>', UP = '^', DOWN = 'v'].freeze
  end
  # @param rows [Array<Array<Point>>]
  # @param robot_pos = [Array<Integer>] [x,y]
  def initialize(rows, robot_pos)
    @rows = rows
    @robot_pos = robot_pos
    @height = rows.count
    @width = rows.first.count
  end

  def move_robot(direction)
    d_vector = _d_vector(direction)
    empty_space = _next_empty_space(@robot_pos, d_vector)
    return unless empty_space

    robot = @rows[@robot_pos[1]][@robot_pos[0]]
    _move_robot(empty_space, robot, d_vector)
  end

  def sum_of_gps_scores
    @rows.flatten.sum(&:gps_score)
  end

  private

  # @param empty_space [Point]
  # @param robot [Point]
  def _move_robot(empty_space, robot, d_vector)
    robot.shape = '.'
    @robot_pos = [robot.x + d_vector[0], robot.y + d_vector[1]]
    new_robot = @rows[@robot_pos[1]][@robot_pos[0]]

    if new_robot.has_box?
      empty_space.shape = 'O'
    end

    new_robot.shape = '@'
    new_robot
  end

  # @return Either[Point, nil] [x,y] or nil if none exists
  def _next_empty_space(pos, d_vector)  
    i = 1
    while true
      movement = d_vector.map { |v| v * i }
      x, y = pos.zip(movement).map(&:sum) # perspective position

      point = @rows[y][x]
      return nil if point.is_wall?
      return point if point.is_empty?
      i += 1
    end
  end

  # @return [Array[Integer]] [x_change, y_change]
  def _d_vector(direction)
    case direction
    when Directions::RIGHT  then [ 1,  0]
    when Directions::LEFT   then [-1,  0]
    when Directions::UP     then [ 0, -1]
    when Directions::DOWN   then [ 0,  1]
    end
  end
end

rows = []
movements = []
robot_pos = []
drawing_map = true
File.open('2024/day_15_lanternfish/input.txt', "r").each_line.with_index do |line, y|
  if drawing_map
    row = line.strip.split('').each_with_index.map { |shape, x| Point.new(x, y, shape) }
    next drawing_map = false if row.empty?

    robot = row.detect(&:has_robot?)
    robot_pos = [robot.x, robot.y] if robot
    
    rows << row
  else
    movements += line.strip.split('')
  end
end

map = Map.new(rows, robot_pos)

movements.each do |direction|
  map.move_robot(direction)
end

pp map.sum_of_gps_scores