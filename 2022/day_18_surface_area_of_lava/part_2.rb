class Cube
  attr_accessor :is_filled, :is_part_of_lava
  attr_reader :x, :y, :z
  def initialize(x,y,z)
    @x = x
    @y = y
    @z = z
    Cube.all << self
  end

  def count_contact_with_fill
    sa = 0

    sa += 1 if Cube.find((@x - 1),@y,@z).is_filled
    sa += 1 if Cube.find((@x + 1),@y,@z).is_filled
    sa += 1 if Cube.find(@x,(@y - 1),@z).is_filled
    sa += 1 if Cube.find(@x,(@y + 1),@z).is_filled
    sa += 1 if Cube.find(@x,@y,(@z - 1)).is_filled
    sa += 1 if Cube.find(@x,@y,(@z + 1)).is_filled

    sa
  end

  def self.all
    @@all ||= []
  end

  def self.max_index
    @@length_of_container ||= Cube.all.map(&:x).max
  end

  def self.find(x,y,z)
    Cube.all.detect { |cube| cube.x == x && cube.y == y && cube.z == z }
  end

  def self.flood_fill(cube)
    cube.is_filled = true

    #left right
    _visit_pos(cube.x - 1, cube.y, cube.z)
    _visit_pos(cube.x + 1, cube.y, cube.z)

    #down up
    _visit_pos(cube.x, cube.y - 1, cube.z)
    _visit_pos(cube.x, cube.y + 1, cube.z)

    #back front
    _visit_pos(cube.x, cube.y, cube.z - 1)
    _visit_pos(cube.x, cube.y, cube.z + 1)
  end

  private

  def self._visit_pos(x,y,z)
    return if [x,y,z].any? { |p| p > Cube.max_index || p < 0 }
    cube = Cube.find(x,y,z)
    return if cube.is_part_of_lava
    return if cube.is_filled

    Cube.flood_fill(cube)
  end
end

def read_file(file)
  f = File.open(file, "r")
  f.each_line do |line|
    x,y,z = line.strip.split(',').map(&:to_i)
    
    # bcause the original coordinates go to zero, I shift everything over
    # one so I don't have to work that hard with the outer box fill
    Cube.find((x + 1),(y + 1),(z + 1)).is_part_of_lava = true
  end
end

use_input = true
length_of_container = use_input ? 22 : 9

length_of_container.times do |x|
  length_of_container.times do |y|
    length_of_container.times do |z|
      Cube.new(x,y,z)
    end
  end
end

file = use_input ? '2022/day_18/input.txt' : '2022/day_18/example.txt'
read_file(file)

Cube.flood_fill(Cube.find(0,0,0))

surface_area = 0
Cube.all.select(&:is_part_of_lava).each do |cube|
  surface_area += cube.count_contact_with_fill
end

puts surface_area
