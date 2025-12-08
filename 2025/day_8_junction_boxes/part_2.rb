class JunctionBox
  attr_reader :x, :y, :z, :id
  def initialize(x, y, z, id)
    @x = x
    @y = y
    @z = z
    @id = id
  end

  # memorize the distance to another box so we don't have to recalculate it
  # @param box [JunctionBox]
  def distance_to(box)
    Math.sqrt((@x - box.x)**2 + (@y - box.y)**2 + (@z - box.z)**2)
  end
end

class Circuit
  attr_reader :box_ids
  # @param id_pair [Array<Integer>] eg [0,19]
  def initialize(id_pair)
    @box_ids = id_pair.sort
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

  # needed so I can use 'uniq!'
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

  def form_one_massive_circuit
    # array of distances from shortest to longest
    sorted_keys = @distances.keys.sort
    key_index = 0

    # this is to keep track of the last pair added to solve the problem
    latest_pair = []

    until _we_have_made_one_massive_circuit?
      @distances[sorted_keys[key_index]].each do |id_pair|
        break if _we_have_made_one_massive_circuit?

        if _matching_circuit?(id_pair)
          _combine_circuits
        else
          @circuits << Circuit.new(id_pair)
        end

        latest_pair = id_pair
      end
      key_index += 1
    end

    # This was the last connection needed to make the one massive circuit
    @last_pair = latest_pair
    @circuits.uniq!
  end

  def solve
    @boxes.select { |box| box.id == @last_pair[0] || box.id == @last_pair[1] }.map(&:x).reduce(:*)
  end

  private

  def _we_have_made_one_massive_circuit?
    @circuits.size == 1 && @circuits[0].box_ids.size == @boxes.size
  end

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
playground.form_one_massive_circuit
puts playground.solve
