class Point
  attr_reader :x_pos, :y_pos, :shape

  # @param x_pos [Integer]
  # @param y_pos [Integer]
  # @param shape [String]
  def initialize(x_pos, y_pos, shape)
    @x_pos = x_pos
    @y_pos = y_pos
    @shape = shape
    @antinodes = []
  end

  def is_node?
    @shape != '.'
  end

  def has_antinode?
    @antinodes.size > 0
  end

  def place_antinode(shape)
    @antinodes << shape unless @antinodes.include?(shape)
  end
end

class Map
  # @param points [Array[Array[Point]]]
  def initialize(rows)
    @rows = rows
    @height = rows.count
    @width = rows.first.count

    @nodes = _nodes(rows)
    @unique_node_shapes = _unique_node_shapes(@nodes)
  end

  # @return [Integer]
  def count_antinodes
    _place_antinodes
    _count_antinodes
  end

  private

  def _count_antinodes
    @rows.flatten.count(&:has_antinode?)
  end
  

  def _place_antinodes
    # Array[Point] containing at least two of the same shape
    node_groups = @unique_node_shapes.map do |shape|
      @nodes.select { |p| p.shape == shape }
    end.reject { |g| g.size == 1 }

    # makes pairings of nodes that share a shape
    pairs = node_groups.flat_map { |g| g.combination(2).to_a }

    pairs.each do |pair|
      x_diff = pair[0].x_pos - pair[1].x_pos
      y_diff = pair[0].y_pos - pair[1].y_pos

      i = 0
      while true
        break unless _place_antinode(pair[0].x_pos + (x_diff * i), pair[0].y_pos + (y_diff * i), pair[1].shape)
        i += 1
      end

      i = 0
      while true
        break unless _place_antinode(pair[1].x_pos - (x_diff * i), pair[1].y_pos - (y_diff * i), pair[1].shape)
        i += 1
      end
    end
  end

  # puts that antinode shape on the given coordinates
  # @return true if placement succeeds, 0 if off map
  def _place_antinode(x_pos, y_pos, shape)
    return false if _off_map?(x_pos, y_pos)

    @rows[y_pos][x_pos].place_antinode(shape)
    true
  end

  # @param coordinates [Array[Intiger]]
  # @return [Boolean]
  def _off_map?(x, y)
    return true if x < 0
    return true if y < 0
    return true if x >= @width
    return true if y >= @height
    false
  end

  # @return [Array[Point]]
  def _nodes(rows)
    rows.flat_map do |row|
      row.filter_map do |point|
        point.is_node? ? point : nil
      end
    end
  end

  def _unique_node_shapes(nodes)
    nodes.map(&:shape).uniq
  end
end


file = '2024/day_8_anteni/input.txt'
rows = []

f = File.open(file, "r")
f.each_line.with_index do |line, y_pos|
  rows << line.strip.split('').each_with_index.map do |shape, x_pos|
    Point.new(x_pos, y_pos, shape)
  end
end

map = Map.new(rows)

pp map.count_antinodes