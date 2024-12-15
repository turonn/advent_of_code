# frozen_string_literal: true

class Point
  attr_reader :x, :y
  attr_accessor :shape

  BOX_SHAPES = ['[', ']'].freeze

  def initialize(x,y,shape)
    @x = x
    @y = y
    @shape = shape
  end

  def has_robot?
    @shape == '@'
  end

  def left_box?
    @shape == '['
  end

  def right_box?
    @shape == ']'
  end

  def has_box?
    left_box? || right_box?
  end

  def is_empty?
    @shape == '.'
  end

  def is_wall?
    @shape == '#'
  end

  def gps_score
    return 0 unless left_box?
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
    robot = @rows[@robot_pos[1]][@robot_pos[0]]
    points_to_change = _points_to_change(robot, d_vector)
    return unless points_to_change

    _change_points(points_to_change, d_vector)
    @robot_pos = @robot_pos.zip(d_vector).map(&:sum)
  end

  def sum_of_gps_scores
    @rows.flatten.sum(&:gps_score)
  end

  private

  def _change_points(points, d_vector)
    grouped_points =  if d_vector[1] == 0 # moving left-right
                        points.group_by(&:x)
                      else
                        points.group_by(&:y)
                      end

    keys = grouped_points.keys.sort
    # if moving > or v we want to start at the end and work backwards
    keys = keys.reverse if d_vector.include?(1) 

    inverted_vector = d_vector.map { |v| v * - 1 }

    keys.each do |key|
      grouped_points[key].each do |point|
        _change_point(point, inverted_vector, points)
      end
    end
  end

  # move other point into this point's space
  def _change_point(point, vector, points_that_are_changing)
    other_point = @rows[point.y + vector[1]][point.x + vector[0]]
    if points_that_are_changing.include?(other_point)
      point.shape = other_point.shape
    else
      # don't "carry forward" points that aren't changing! This was the cause of my issue!
      point.shape = '.'
    end
  end

  # this will include the empty space(s) at the edge
  # @param robot [Point]
  # @param d_vector [Array<Integer>] [x,y]
  # @return [Array<Point>] empty if not movable
  def _points_to_change(robot, d_vector)
    if d_vector[1] == 0 # moving left-right
      _points_to_change_left_right(robot, d_vector)
    else
      _points_to_change_up_down(robot, d_vector)
    end
  end

  # @return [Array<Point>] empty if not movable
  def _points_to_change_left_right(robot, d_vector)
    points_to_change = [robot]

    starting_pos = [robot.x, robot.y]
    i = 1
    while true
      movement = d_vector.map { |v| v * i }
      x, y = starting_pos.zip(movement).map(&:sum) # perspective position

      point = @rows[y][x]
      return nil if point.is_wall?

      points_to_change << point
      return points_to_change if point.is_empty?
      i += 1
    end
  end

  # @return [Array<Point>] empty if not movable
  def _points_to_change_up_down(robot, d_vector)
    points_to_change = []
    front_line_points = [robot]

    while true
      perspective_points = front_line_points.flat_map do |point|
        perspective_point = @rows[point.y + d_vector[1]][point.x + d_vector[0]]
        _point_pair(perspective_point)
      end

      return nil if perspective_points.any?(&:is_wall?)
      
      points_to_change += (front_line_points + perspective_points)
      front_line_points = perspective_points.select { |point| point.has_box? }
      return points_to_change if front_line_points.empty?
    end
  end

  # @return [Array<Point>]
  def _point_pair(point)
    if point.left_box?
      [point, @rows[point.y][point.x + 1]]
    elsif point.right_box?
      [point, @rows[point.y][point.x - 1]]
    else
      [point]
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
    row = line.strip.split('').each_with_index.flat_map do  |shape, x|
      case shape
      when '#','.'  then [Point.new(x * 2, y, shape), Point.new(x * 2 + 1, y, shape) ]
      when 'O'      then [Point.new(x * 2, y, '['),   Point.new(x * 2 + 1, y, ']') ]
      when '@'      then [Point.new(x * 2, y, '@'),   Point.new(x * 2 + 1, y, '.') ]
      end
    end
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