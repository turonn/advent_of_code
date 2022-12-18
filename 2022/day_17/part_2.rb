class Rock
  attr_reader :shape, :name, :initial_coords, :height, :width, :right_coords, :left_coords, :bottom_coords

  @@all ||= []

  def initialize(shape,name)
    @shape = shape
    @name = name
    _set_initial_coords

    @height = shape.length
    @width = shape.first.length

    _set_right_coords
    _set_left_coords
    _set_bottom_coords

    @@all << self
  end

  def reset_coords
    @current_coords = initial_coords
  end

  def move_down
    @current_coords.map! do |coord|
      {
        y: coord[:y] + 1,
        x: coord[:x]
      }
    end
  end

  def self.all
    @@all
  end

  def self.find(name)
    all.detect { |rock| rock.name == name }
  end

  private

  def _set_bottom_coords
    @bottom_coords = @width.times.map do |i|
      @initial_coords.select { |coord| coord[:x] == i }.max_by { |coord| coord[:y] }
    end
  end

  def _set_right_coords
    @right_coords = @height.times.map do |i|
      @initial_coords.select { |coord| coord[:y] == i }.max_by { |coord| coord[:x] }
    end
  end

  def _set_left_coords
    @left_coords = @height.times.map do |i|
      @initial_coords.select { |coord| coord[:y] == i }.min_by { |coord| coord[:x] }
    end
  end

  def _set_initial_coords
    coords = []
    @shape.each_with_index do |row, y|
      row.each_with_index do |val, x|
        if val == "@"
          coords << {y: y, x: x}
        end
      end
    end

    @initial_coords = coords
  end
end

class Tunnel
  attr_reader :stopped_rock_count

  def initialize(gas_directions)
    @gas_directions = gas_directions
    @gas_index = 0
    @gas_cycle_length = gas_directions.count
    @stopped_rock_count = 0
    @tunnel = [Array.new(7, "#")]
    _initialize_rocks
  end

  def height_of_tallest_rock
    # removes empty rows
    index = 0
    until @tunnel[index].include?("#")
      index += 1
    end
    
    @tunnel.count - index
  end

  def drop_rock
    rock = _select_rock
    adjustment = {y:0, x:2}
    _add_or_remove_space_to_tunnel(rock.height)
    _place_rock_in_position(rock.initial_coords, adjustment)

    # _check_if_end_of_period(rock)

    # is_start_of_period = _check_if_

    until _rock_touches_floor(rock.bottom_coords, adjustment)
      _wipe_location(rock.initial_coords, adjustment)
      adjustment = { y: adjustment[:y] + 1, x: adjustment[:x] }
      adjustment = _blow_rock_adjustment(adjustment, rock)
      @gas_index += 1
      _place_rock_in_position(rock.initial_coords, adjustment)
    end

    _stop_rock(rock.initial_coords, adjustment)
    
  end

  private

  def _stop_rock(rock_coords, adjustment)
    rock_coords.each do |coord|
      @tunnel[coord[:y] + adjustment[:y]][coord[:x] + adjustment[:x]] = '#'
    end

    @stopped_rock_count += 1
  end

  def _blow_rock_adjustment(adjustment, rock)
    if @gas_directions[@gas_index % @gas_cycle_length] == "<"
      return adjustment if _at_left_wall(adjustment)
      return adjustment if _touching_left_rock(adjustment, rock.left_coords)
      { y: adjustment[:y], x: adjustment[:x] - 1}
    else
      return adjustment if _at_right_wall(adjustment, rock.width)
      return adjustment if _touching_right_rock(adjustment, rock.right_coords)

      { y: adjustment[:y], x: adjustment[:x] + 1}
    end
  end

  def _rock_touches_floor(bottom_coords, adjustment)
    bottom_coords.each do |coord|
      y = coord[:y] + adjustment[:y] + 1
      x = coord[:x] + adjustment[:x]
      return true if @tunnel[y][x] == "#"
    end

    false
  end

  def _touching_right_rock(adjustment, right_coords)
    right_coords.each do |coord|
      y = coord[:y] + adjustment[:y]
      x = coord[:x] + adjustment[:x] + 1
      return true if @tunnel[y][x] == "#"
    end

    false
  end

  def _touching_left_rock(adjustment, left_coords)
    left_coords.each do |coord|
      y = coord[:y] + adjustment[:y]
      x = coord[:x] + adjustment[:x] - 1
      return true if @tunnel[y][x] == "#"
    end

    false
  end

  def _at_left_wall(adjustment)
    adjustment[:x] == 0
  end

  def _at_right_wall(adjustment, rock_width)
    adjustment[:x] + rock_width == 7
  end

  def _place_rock_in_position(rock_coords, adjustment)
    rock_coords.each do |coord|
      @tunnel[coord[:y] + adjustment[:y]][coord[:x] + adjustment[:x]] = '@'
    end
  end

  def _wipe_location(rock_coords, adjustment)
    rock_coords.each do |coord|
      @tunnel[coord[:y] + adjustment[:y]][coord[:x] + adjustment[:x]] = '.'
    end
  end

  def _add_or_remove_space_to_tunnel(rock_height)
    bottom_of_new_rock_height = height_of_tallest_rock + 4 # 3 plus one extra to get the sync right
    required_height_of_tunnel = bottom_of_new_rock_height + rock_height

    height_to_change = required_height_of_tunnel - @tunnel.size

    if height_to_change >= 0
      height_to_change.times do
        @tunnel.unshift(Array.new(7, "."))
      end
    else
      height_to_change.abs.times do
        @tunnel.shift
      end
    end
  end

  def _select_rock
    name =  case @stopped_rock_count % 5
            when 0 then "minus"
            when 1 then "plus"
            when 2 then "j"
            when 3 then "l"
            when 4 then "square"
            end
    Rock.find(name)
  end

  def _initialize_rocks
    Rock.new(
      [['@', '@', '@', '@']],
      "minus"
    )
    Rock.new(
      [
        ['.', '@', '.'],
        ['@', '@', '@'],
        ['.', '@', '.']
      ],
      "plus"
    )
    Rock.new(
      [
        ['.', '.', '@'],
        ['.', '.', '@'],
        ['@', '@', '@']
      ],
      "j"
    )
    Rock.new(
      [
        ['@'],
        ['@'],
        ['@'],
        ['@']
      ],
      "l"
    )
    Rock.new(
      [
        ['@', '@'],
        ['@', '@']
      ],
      "square"
    )
  end
end

def read_file(file)
  f = File.open(file, 'r')
  f.each_line.flat_map do |line|
    line.strip.split('')
  end
end

use_input = true
file = use_input ? '2022/day_17/input.txt' : '2022/day_17/example.txt'
gas_directions = read_file(file)

tunnel = Tunnel.new(gas_directions)

until tunnel.stopped_rock_count == 2022
  tunnel.drop_rock
end

# need to remove one to account for the floor
puts (tunnel.height_of_tallest_rock) - 1
