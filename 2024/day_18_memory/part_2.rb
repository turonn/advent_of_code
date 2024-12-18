# frozen_string_literal: true

class Point
  attr_reader :x, :y, :shape, :order
  attr_accessor :score, :been_visited, :prior_point

  def initialize(x,y,order = nil,score = nil)
    @x = x
    @y = y
    @order = order || Float::INFINITY
    @score = score || Float::INFINITY
    @been_visited = false
    @prior_point = nil
    @is_blocked = false
  end

  def been_visited?
    been_visited
  end

  def not_visited
    !@been_visited
  end

  def block
    @is_blocked = true
    @score = Float::INFINITY
    self
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
        point ||= Point.new(x,y)
        row << point
      end
      @rows << row
    end
    @goal = @rows[size][size]
    @size = size
    @no_solution = false
    @elapsed_time = 0
    @path = []
  end

  # @return [Integer]
  def time_until_no_solution
    until @no_solution
      _clear_board
      until _reached_goal? || @no_solution
        _visit_next_point
      end

      break if @no_solution

      _draw_new_path

      point = _increment_time
      
      until point.nil? || @path.include?(point)
        point = _increment_time
        @no_solution = true if point.nil?
      end

      pp @elapsed_time
      break if @no_solution

      _print_map
    end

    pp "no_solution" if @no_solution
    @elapsed_time
  end

  private

  def _clear_board
    @rows.flatten.each do |point|
      point.score = Float::INFINITY unless point.score == 0
      point.been_visited = false
      point.prior_point = nil
    end
  end

  # @return Either[Point,nil]
  def _increment_time
    @elapsed_time += 1
    point = @rows.flatten.detect { |p| p.order == @elapsed_time }
    return if point.nil?
    point.block
  end
  
  def _visit_next_point
    point = _next_point_to_visit
    return _no_solution if point.nil?
    _visit_point(point)
  end

  def _next_point_to_visit
    # the lowest scored point that has not been visited
    @rows.flatten.select { |p| p.not_visited && p.score != Float::INFINITY }.min
  end

  def _visit_point(point)
    _score_surroundings(point)
    point.been_visited = true
  end

  def _score_surroundings(point)
    _look(point.x + 1, point.y,     point)
    _look(point.x - 1, point.y,     point)
    _look(point.x,     point.y + 1, point)
    _look(point.x,     point.y - 1, point)
  end

  def _look(x, y, prior_point)
    return if _off_map?(x,y)
    point = @rows[y][x]
    return if point.is_blocked?
    score = prior_point.score + 1
    return if point.score < score
    
    point.score = score
    point.prior_point = prior_point
    point.been_visited = false
  end

  def _off_map?(x, y)
    return true if x < 0
    return true if y < 0
    return true if x > @size
    return true if y > @size
    false
  end

  def _draw_new_path
    @path = []
    point = @goal
    until point.nil?
      @path << point
      point = point.prior_point
    end
  end

  def _reached_goal?
    @goal.been_visited?
  end
  
  def _no_solution
    @no_solution = true
  end

  def _print_map
    @rows.each do |row|
      r = row.map do |point|
        if @path.include?(point)
          "O"
        elsif point.is_blocked?
          "#"
        else
          "."
        end
      end

      puts r.join(' ')
    end
  end
end

is_example = false

if is_example
  size = 6
  limit = 12
  file = '2024/day_18_memory/example.txt'
else
  size = 70
  limit = 1024
  file = '2024/day_18_memory/input.txt'
end

points = [Point.new(0,0,Float::INFINITY,0), Point.new(size,size)]

order = 0
File.open(file, "r").each_line do |line|
  coord = line.strip.split(',').map(&:to_i)
  order += 1
  points << Point.new(coord[0], coord[1], order)
end

map = Map.new(points, size)

time = map.time_until_no_solution
pp "time #{time}"
point = points.detect { |p| p.order == time }

pp "#{point.x},#{point.y}"

# map.rows.each do |row|
#   puts row.map(&:score).join ' '
# end