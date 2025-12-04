class Space
  attr_reader :x, :y
  attr_accessor :neighbors
  def initialize(x, y, value)
    @x = x
    @y = y
    @value = value
    @neighbors = []
    @adjacent_rolls = 0
    @satisfies_condition = false
  end

  def count_neighbors
    @adjacent_rolls = @neighbors.count(&:has_roll?)
    @satisfies_condition = @adjacent_rolls < 4
  end

  def remove_roll
    @value = 'x'
    @neighbors.each(&:count_neighbors)
  end

  def has_roll?
    @value == '@'
  end

  def satisfies_condition?
    @satisfies_condition
  end
end

class Map
  attr_reader :removed_rolls

  # @param rows [Array<Array<Space>>]
  def initialize(rows)
    @rows = rows
    @width_index = rows.first.length - 1
    @height_index = rows.length - 1
    @total_rolls = []
    @removed_rolls = 0
  end

  def add_neighbors_and_initial_count
    @rows.each_with_index do |row, y|
      row.each_with_index do |space, x|
        # we don't need to count the neighbors if the space doesn't have a roll
        next unless space.has_roll?

        if y > 0
          # up
          space.neighbors << @rows[y-1][x]
          # up left
          space.neighbors << @rows[y-1][x-1] if x > 0
          # up right
          space.neighbors << @rows[y-1][x+1] if x < @width_index
        end

        if y < @height_index
          # down
          space.neighbors << @rows[y+1][x]
          # down left
          space.neighbors << @rows[y+1][x-1] if x > 0
          # down right
          space.neighbors << @rows[y+1][x+1] if x < @width_index
        end

        # left
        space.neighbors << @rows[y][x-1] if x > 0
        # right
        space.neighbors << @rows[y][x+1] if x < @width_index

        space.count_neighbors
        @total_rolls << space
      end
    end
  end

  def remove_and_count
    removed_at_least_one_roll = true

    while removed_at_least_one_roll
      removed_at_least_one_roll = false

      @total_rolls.each do |space|
        next unless space.satisfies_condition?

        space.remove_roll
        @removed_rolls += 1
        removed_at_least_one_roll = true
      end

      @total_rolls.select!(&:has_roll?)
    end
  end
end

rows = []
File.open('2025/day_4_forklift/input.txt', "r").each_line.with_index do |line, y|
  row = line.strip.split('').each_with_index.map do |value, x|
    Space.new(x, y, value)
  end
  rows << row
end

map = Map.new(rows)

map.add_neighbors_and_initial_count
map.remove_and_count
puts map.removed_rolls
