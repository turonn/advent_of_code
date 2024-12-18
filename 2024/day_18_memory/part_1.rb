# frozen_string_literal: true

class Point
  attr_reader :x, :y, :shape, :order
  attr_accessor :score, :been_visited

  def initialize(x,y,shape,order)
    @x = x
    @y = y
    @been_visited = false
    @shape = shape
    @order = order

    case shape
    when 'S'
      @is_blocked = false
      @score = 0
    when '#'
      @is_blocked = true
      @score = Float::INFINITY
    else
      @is_blocked = false
      @score = Float::INFINITY
    end
  end

  def been_visited?
    been_visited
  end
  def not_visited
    !@been_visited
  end

  def is_blocked?
    @is_blocked
  end

  # allows me to use 'min'
  def <=>(other)
    @score <=> other.score
  end
end

class Map
  attr_reader :rows
  def initialize(points, size)
    @rows = []
    (0..size).each do |y|
      row = []
      (0..size).each do |x|
        point = points.detect { |point| point.x == x && point.y == y }
        point ||= Point.new(x,y,".",Float::INFINITY)
        row << point
      end
      @rows << row
    end
    @goal = @rows[size][size]
    @size = size
  end

  # @return [Integer]
  def find_path_to_goal
    until _reached_goal?
      _visit_next_point
    end

    @goal.score
  end

  private
  
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
    _look(point.x + 1, point.y,     point.score + 1)
    _look(point.x - 1, point.y,     point.score + 1)
    _look(point.x,     point.y + 1, point.score + 1)
    _look(point.x,     point.y - 1, point.score + 1)
  end

  def _look(x, y, score)
    return if _off_map?(x,y)
    point = @rows[y][x]
    return if point.is_blocked?
    return if point.score < score
    
    point.score = score
    point.been_visited = false
  end

  def _off_map?(x, y)
    return true if x < 0
    return true if y < 0
    return true if x > @size
    return true if y > @size
    false
  end

  def _reached_goal?
    @goal.been_visited?
  end
end

if false
  size = 6
  limit = 12
else
  size = 70
  limit = 1024
end

points = [Point.new(0,0,'S', Float::INFINITY), Point.new(size,size,'E', Float::INFINITY)]

order = 0
File.open('2024/day_18_memory/input.txt', "r").each_line do |line|
  coord = line.strip.split(',').map(&:to_i)
  order += 1

  break if order > limit
  points << Point.new(coord[0], coord[1], '#', order)
end

map = Map.new(points, size)

pp map.find_path_to_goal

# map.rows.each do |row|
#   puts row.map(&:score).join ' '
# end