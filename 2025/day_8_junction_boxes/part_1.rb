class JunctionBox
  attr_reader :x, :y, :z, :id
  def initialize(x, y, z, id)
    @x = x
    @y = y
    @z = z
    @id = id
    @connections = []
    @distances = { @id => Float::INFINITY }
  end

  # memorize the distance to another box so we don't have to recalculate it
  # @param box [JunctionBox]
  def distance_to(box)
    @distances[box.id] ||= Math.sqrt((@x - box.x)**2 + (@y - box.y)**2 + (@z - box.z)**2)
  end

  # @add the new box to this circuit unless it's already connected
  def connect_to(box)
    return if @connections.detect { |b| b.id == box.id }
    @connections << box
  end
end

class Circuit
  attr_reader :box_ids
  # @param id_pair [Array<Integer>] eg [0,19]
  def initialize(id_pair)
    @box_ids = id_pair.sort
  end

  # The "fence links" between fence posts
  def wires
    @box_ids.size - 1
  end

  def include?(id)
    @box_ids.include?(id)
  end

  # @param ids [Array<Integer>]
  def add_ids(ids)
    ids.each do |id|
      @box_ids << id unless include?(id)
    end
    @box_ids.sort!
  end

  # @param other [Circuit]
  def merge_if_possible(other)
    return unless @box_ids.any? { |id| other.include?(id) }

    add_ids(other.box_ids)
  end

  def == (other)
    @box_ids == other.box_ids
  end
  alias eql? ==
  def hash
    @box_ids.hash
  end
end

class Playground
  def initialize
    @boxes = []
    @distances = {} # key is distance, value are the pairs of boxes
    @circuits = []
  end

  # @param boxes [Array<JunctionBox>]
  def add_box(box)
    @boxes << box
  end

  def measure_all_distances
    @boxes.each do |box|
      @boxes.each do |other_box|
        next if box.id == other_box.id
        dist = box.distance_to(other_box)
        id_pair = [box.id, other_box.id].sort

        @distances[dist] ||= []
        @distances[dist] << id_pair unless @distances[dist].include?(id_pair)
      end
    end
  end

  def make_10_connections
    # array of arrays, each inner array are the ids of the the junction boxes
    sorted_keys = @distances.keys.sort
    key_index = 0
    connections = 0
    until connections >= 1000
      @distances[sorted_keys[key_index]].each do |id_pair|
        # if we have enough wires, exit the loop entirely
        break if connections >= 1000

        if _matching_circuit?(id_pair)
          _combine_circuits
        else
          @circuits << Circuit.new(id_pair)
        end

        connections += 1
      end
      key_index += 1
    end

    @circuits.uniq!
  end

  def solve
    @circuits.map { |c| c.box_ids.size }.sort.last(3).reduce(:*)
  end

  private

  # @param id_pair [Array<Integer>] eg [0,19]
  # @return [Boolean] true if the pair was added to an existing circuit
  def _matching_circuit?(id_pair)
    @circuits.each do |circuit|
      if circuit.include?(id_pair[0]) || circuit.include?(id_pair[1])
        circuit.add_ids(id_pair)
        return true
      end
    end

    false
  end

  def _combine_circuits
    @circuits.each do |circuit|
      @circuits.each do |other_circuit|
        circuit.merge_if_possible(other_circuit)
      end
    end

    # once they have been merged, they will be `eql?`, so we can just uniq! the array
    @circuits.uniq!
  end
end

playground = Playground.new
File.open('2025/day_8_junction_boxes/input.txt', "r").each_line.with_index do |line, id|
  arr = line.strip.split(',').map(&:to_i)
  playground.add_box(JunctionBox.new(arr[0], arr[1], arr[2], id))
end

playground.measure_all_distances
playground.make_10_connections
puts playground.solve
