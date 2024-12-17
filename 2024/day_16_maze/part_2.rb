# frozen_string_literal: true

class Point
  attr_reader :x, :y, :shape
  attr_accessor :score, :been_visited, :direction, :prior_scores

  def initialize(x,y,shape)
    @x = x
    @y = y
    @been_visited = false
    @shape = shape
    @prior_scores = []

    case shape
    when 'S'
      @is_wall = false
      @score = 0
      # the direction from which the point has been entered.
      @direction = Maze::Directions::EAST
    when '#'
      @is_wall = true
      @score = Float::INFINITY
      @direction = nil
    else
      @is_wall = false
      @score = Float::INFINITY
      @direction = nil
    end
  end

  def been_visited?
    been_visited
  end
  def not_visited
    !@been_visited
  end

  def scored?
    !@score.nil?
  end

  def is_wall?
    @is_wall
  end

  # allows me to use 'min'
  def <=>(other)
    @score <=> other.score
  end
end

class Maze
  module Directions
    ALL = [EAST = "East", NORTH = "North", WEST = "West", SOUTH = "South"].freeze
  end

  OPPOSITES = {
    Directions::EAST => Directions::WEST,
    Directions::WEST => Directions::EAST,
    Directions::NORTH => Directions::SOUTH,
    Directions::SOUTH => Directions::NORTH
  }

  RIGHT_ANGLES = {
    Directions::EAST => [Directions::NORTH, Directions::SOUTH],
    Directions::WEST => [Directions::NORTH, Directions::SOUTH],
    Directions::NORTH => [Directions::EAST, Directions::WEST],
    Directions::SOUTH => [Directions::EAST, Directions::WEST]
  }

  def initialize(rows, goal)
    @rows = rows
    @goal = goal
  end

  # @return [Integer]
  def find_path_to_goal
    until _reached_goal?
      _visit_next_point
    end

    @goal.score
  end

  def count_seats
    seats = []
    current_points = [@goal]

    until current_points.empty?
      seats += current_points

      current_points = current_points.flat_map do |cur_point| 
        nei_points = _neighbor_nei_(cur_point.x, cur_point.y)
        nei_points.select { |point| cur_point.prior_scores.include?(point.score) }
      end
    end

    seats.uniq.count
  end

  private

  # @return [Array<Point>]
  def _neighbor_points(x, y)
    [
      @rows[y + 1][x    ],
      @rows[y - 1][x    ],
      @rows[y    ][x + 1],
      @rows[y    ][x - 1]
    ]
  end
  
  def _visit_next_point
    point = _next_point_to_visit
    _visit_point(point)
  end

  def _next_point_to_visit
    # the lowest scored point that has not been visited
    @rows.flatten.select(&:not_visited).min
  end

  def _visit_point(point)
    _score_surroundings(point)
    point.been_visited = true
  end

  def _score_surroundings(point)
    _look(@rows[point.y + 1][point.x    ], point,  Directions::SOUTH)
    _look(@rows[point.y - 1][point.x    ], point,  Directions::NORTH)
    _look(@rows[point.y    ][point.x + 1], point,  Directions::EAST )
    _look(@rows[point.y    ][point.x - 1], point,  Directions::WEST )
  end

  def _look(point, prior_point, direction)
    return if point.is_wall?

    score = _score(prior_point, direction)

    # check for convergence on on something already scored better.
    if point.score == score - 1000 && RIGHT_ANGLES[point.direction].include?(direction)
      point.prior_scores << prior_point.score
    end

    return if point.score < score
    
    # check for convergance on somethign already scored worse.
    if point.score == score + 1000 && RIGHT_ANGLES[point.direction].include?(direction)
      point.prior_scores << prior_point.score
    else
      point.prior_scores = [prior_point.score]
    end

    point.score = score
    point.been_visited = false
    point.direction = direction
  end

  def _score(point, direction)
    if point.direction == direction
      point.score + 1
    elsif OPPOSITES[point.direction] == direction
      point.score + 2001
    else
      point.score + 1001
    end
  end

  def _reached_goal?
    @goal.been_visited?
  end
end

rows = []
start = nil
goal = nil

File.open('2024/day_16_maze/input.txt', "r").each_line.with_index do |line, y|
  row = line.strip.split('').each_with_index.map { |shape, x| Point.new(x,y,shape) }
  rows << row
  start ||= row.detect { |p| p.shape == 'S' }
  goal ||= row.detect { |p| p.shape == 'E' }
end

maze = Maze.new(rows, goal)

pp maze.find_path_to_goal

# def print_aligned_scores(rows)
#   rows.each do |row|
#     formatted_row = row.map do |point|
#       if point.is_wall?
#         "  ###" # Represents a wall
#       elsif point.shape == "E" || point.shape == "S"
#         format("%5s", point.shape) # Start or Goal shape
#       elsif point.score.infinite?
#         "  INF" # Represents Infinity
#       else
#         format("%05d", point.score) # Leading zeros for scores < 5 characters
#       end
#     end
#     puts formatted_row.join(" ")
#   end
# end

# # Call the function with the maze rows
# print_aligned_scores(rows)


pp maze.count_seats

# 499 is too high