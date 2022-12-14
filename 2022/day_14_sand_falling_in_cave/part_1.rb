class Map
  attr_reader :points, :outside_the_map
  def initialize
    @points = []
  end

  def collect_points(s, e)
    # the input gives the points as [x,y] but we need to flip that
    # to [y,x] to treat it like a normal array map
    if s[0] == e[0]
      x = s[0]
      ys = [s[1], e[1]].min
      ((e[1] - s[1]).abs + 1).times do |index|
        @points << [ys + index, x]
      end
    else
      xs = [s[0], e[0]].min
      y = s[1]
      ((e[0] - s[0]).abs + 1).times do |index|
        @points << [y, xs+ index]
      end
    end
  end

  def drop_piece_of_sand
    @sand_location = [0,500 - @left_edge]
    sand_cannot_move = false

    until sand_cannot_move || @outside_the_map
      next if _move_down_if_possible
      next if _move_down_left_if_possible
      next if _move_down_right_if_possible

      sand_cannot_move = _settle_sand
    end

    # @map.each do |row|
    #   puts row.join('')
    # end

  end

  def plot_points
    _create_map

    @points.each do |point|
      @map[point[0]][point[1] - @left_edge] = "#"
    end

    @map.each do |row|
      puts row.join("")
    end
  end

  private

  def _move_down_if_possible
    perspective_y = @sand_location[0] + 1
    perspective_x = @sand_location[1]
    return true if _outside_the_map(perspective_y, perspective_x)

    if @map[perspective_y][perspective_x] == '.'
      @sand_location = [perspective_y, perspective_x]
      true
    else
      false
    end
  end

  def _move_down_left_if_possible
    perspective_y = @sand_location[0] + 1
    perspective_x = @sand_location[1] - 1
    return true if _outside_the_map(perspective_y, perspective_x)

    if @map[perspective_y][perspective_x] == '.'
      @sand_location = [perspective_y, perspective_x]
      true
    else
      false
    end
  end

  def _move_down_right_if_possible
    perspective_y = @sand_location[0] + 1
    perspective_x = @sand_location[1] + 1
    return true if _outside_the_map(perspective_y, perspective_x)
    
    if @map[perspective_y][perspective_x] == '.'
      @sand_location = [perspective_y, perspective_x]
      true
    else
      false
    end
  end

  def _outside_the_map(perspective_y, perspective_x)
    return @outside_the_map = true if perspective_x < 0
    return @outside_the_map = true if perspective_x > (@map[0].size - 1)
    return @outside_the_map = true if perspective_y > (@map.size - 1)
    false
  end

  def _settle_sand
    @map[@sand_location[0]][@sand_location[1]] = 'o'
    true
  end

  def _create_map
    @map = []
    @points = @points.uniq
    y_vals = @points.map {|point| point[0] }
    x_vals = @points.map {|point| point[1] }

    @left_edge = x_vals.min
    @right_edge = x_vals.max
    @top = y_vals.min
    @bottom = y_vals.max

    @height = @bottom - @top + 1
    @width = @right_edge - @left_edge + 1

    (@bottom + 1).times do
      @map << Array.new(@width, ".")
    end
  end
end

def read_file(file, map)
  f = File.open(file, "r")
  f.each_line do |line|
    # [[498,4],[498,6],[496,6]]
    points = line.strip.split(' -> ').map { |point| point.split(',').map(&:to_i)}

    points.each_with_index do |point, index|
      next if index == 0
      map.collect_points(points[index -1], point)
    end
  end
end

use_input = true
file = use_input ? '2022/day_14/input.txt' : '2022/day_14/example.txt'

map = Map.new
read_file(file, map)
map.plot_points

count = 0
until map.outside_the_map
  map.drop_piece_of_sand
  count += 1
end

puts count - 1