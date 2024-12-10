class Map
  attr_reader :score

  def initialize(rows)
    @rows = rows
    @width = rows.first.count
    @height = rows.count
    @trailheads = []
    @scratch_pad = []
  end

  def find_trailheads
    @rows.each_with_index do |row, y_pos|
      row.each_with_index do |point, x_pos|
        @trailheads << [x_pos, y_pos] if point == 0
      end
    end
  end

  # @return [Integer]
  def score_trailheads
    @trailheads.map do |trailhead|
      winning_coords = _viable_ending_coords(trailhead)
      winning_coords.count
    end.sum
  end

  private

  def _viable_ending_coords(trailhead)
    coords = [trailhead]
    (1..9).each do |next_point|
      new_coords = coords.flat_map do |coord|
          [
          _viable_coord(coord[0] + 1, coord[1]    , next_point), # check right
          _viable_coord(coord[0] - 1, coord[1]    , next_point), # check left
          _viable_coord(coord[0]    , coord[1] + 1, next_point), # check down
          _viable_coord(coord[0]    , coord[1] - 1, next_point), # check up
        ].compact
      end
      return [] if new_coords.empty?

      coords = new_coords
    end

    coords
  end

  # returns [x,y] if viable. Otherwise nil
  def _viable_coord(x, y, target_val)
    return nil if _off_map?(x, y)
    return [x, y] if @rows[y][x] == target_val
    nil
  end

  def _off_map?(x, y)
    return true if x < 0
    return true if y < 0
    return true if x >= @width
    return true if y >= @height
    false
  end
end

rows = []
file = '2024/day_10_hiking/input.txt'
f = File.open(file, "r")
f.each_line do |line|
  rows << line.strip.split('').map(&:to_i)
end

map = Map.new(rows)
map.find_trailheads
pp map.score_trailheads