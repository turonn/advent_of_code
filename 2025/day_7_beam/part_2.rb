class Point
  attr_accessor :split_count

  def initialize(value)
    @value = value
    # we need to start in the _current_ timeline
    @split_count = is_starter? ? 1 : 0
  end

  def is_starter?
    @value == 'S'
  end

  def is_splitter?
    @value == '^'
  end

  # split the beam this many times
  def split(count)
    @split_count += count
  end
end

class Map
  attr_accessor :points

  # @param rows [Array<Array<Point>>]
  def initialize(rows)
    @rows = rows
    @current_row = 0
    starting_index = rows[0].index { |point| point.is_starter? }
    @beam_indexes = { starting_index => 1 }
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
        answer += point.split_count
      end
    end
    answer
  end

  private

  def _advance_row
    @current_row += 1
    new_beam_indexes = @beam_indexes.dup
    @beam_indexes.each do |beam_index, count|
      next unless count.positive?
      point = @rows[@current_row][beam_index]
      if point.is_splitter?
        point.split(count)
        new_beam_indexes[beam_index] = 0

        if beam_index > 0
          new_beam_indexes[beam_index - 1] ||= 0
          new_beam_indexes[beam_index - 1] += count
        end
        if beam_index < @width_index
          new_beam_indexes[beam_index + 1] ||= 0
          new_beam_indexes[beam_index + 1] += count
        end
      end
    end

    @beam_indexes = new_beam_indexes
  end
end

rows = []
File.open('2025/day_7_beam/input.txt', "r").each_line do |line|
  row = line.strip.split('').map do |char|
    Point.new(char)
  end
  rows << row
end
map = Map.new(rows)

puts map.run_experiment
