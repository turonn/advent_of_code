class Map
  attr_reader :points, :outside_the_map, :hole_is_plugged
  def initialize
    @points = []
    @hole_is_plugged = false
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
    @sand_location = [0,500 - @left_edge_buffer]
    sand_cannot_move = false

    until sand_cannot_move || @hole_is_plugged
      next if _hole_is_plugged
      next if _move_down_if_possible
      next if _move_down_left_if_possible
      next if _move_down_right_if_possible

      sand_cannot_move = _settle_sand
    end
  end

  def plot_points
    _create_map

    @points.each do |point|
      @map[point[0]][point[1] - @left_edge_buffer] = "#"
    end
  end

  private

  def _move_down_if_possible
    perspective_y = @sand_location[0] + 1
    perspective_x = @sand_location[1]

    _move_if_can_move(perspective_y, perspective_x)
  end

  def _move_down_left_if_possible
    perspective_y = @sand_location[0] + 1
    perspective_x = @sand_location[1] - 1

    _move_if_can_move(perspective_y, perspective_x)
  end

  def _move_down_right_if_possible
    perspective_y = @sand_location[0] + 1
    perspective_x = @sand_location[1] + 1
    
    _move_if_can_move(perspective_y, perspective_x)
  end

  def _move_if_can_move(y, x)
    return @sand_location = [y, x] if @map[y][x] == '.'
      
    false
  end

  def _hole_is_plugged
    return @hole_is_plugged = true if @map[0][500 - @left_edge_buffer] != '.'
      
    false
  end

  def _settle_sand
    @map[@sand_location[0]][@sand_location[1]] = 'o'
  end

  def _create_map
    @map = []
    @points = @points.uniq
    y_vals = @points.map {|point| point[0] }
    x_vals = @points.map {|point| point[1] }

    left_edge = x_vals.min
    right_edge = x_vals.max
    depth = y_vals.max + 3

    left_edge_from_center = 500 - left_edge
    right_edge_from_center = right_edge - 500

    # the triangle base will be (2 * height) - 1
    # we need to add horizontal distance to account 
    # for the expanding base to make the triangle height
    # reach bottom to top

    columns_to_add_left = depth - left_edge_from_center
    columns_to_add_right = depth - right_edge_from_center
    total_columns_to_add = columns_to_add_left + columns_to_add_right

    width = right_edge - left_edge + 1 + total_columns_to_add

    # even though we are adding width, we are still not
    # going to be close to mapping all the way to zero
    # this buffer will shift our graph to center on the drop
    # point
    @left_edge_buffer = left_edge - columns_to_add_left

    (depth - 1).times do
      @map << Array.new(width, ".")
    end

    # this is the floor
    @map << Array.new(width, "#")
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
until map.hole_is_plugged
  map.drop_piece_of_sand
  count += 1
end

puts count - 1