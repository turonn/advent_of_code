class Point
  attr_accessor :x, :y

  def initialize(x, y, value)
    @x = x
    @y = y
    @value = value
    @has_split = false
  end

  def is_starter?
    @value == 'S'
  end

  def is_splitter?
    @value == '^'
  end

  def split
    @has_split = true
  end

  def has_split?
    @has_split
  end
end

class Map
  attr_accessor :points

  # @param rows [Array<Array<Point>>]
  def initialize(rows)
    @rows = rows
    @current_row = 0
    starting_point = rows[0].detect { |point| point.is_starter? }
    @beam_indexes = [starting_point.x]
    @width_index = rows[0].length - 1
    @height_index = rows.length - 1
  end

  def run_experiment
    until @current_row >= @height_index
      _advance_row
    end

    answer = 0
    @rows.each do |row|
      row.each do |point|
        answer += 1 if point.has_split?
      end
    end
    answer
  end

  private

  def _advance_row
    @current_row += 1
    new_beam_indexes = []
    @beam_indexes.each do |beam_index|
      point = @rows[@current_row][beam_index]
      if point.is_splitter?
        point.split
        new_beam_indexes << beam_index - 1 if beam_index > 0
        new_beam_indexes << beam_index + 1 if beam_index < @width_index
      else
        new_beam_indexes << beam_index
      end
    end

    @beam_indexes = new_beam_indexes.uniq
  end
end

rows = []
File.open('2025/day_7_beam/input.txt', "r").each_line.with_index do |line, y|
  row = line.strip.split('').map.with_index do |char, x|
    Point.new(x, y, char)
  end
  rows << row
end
map = Map.new(rows)

puts map.run_experiment
