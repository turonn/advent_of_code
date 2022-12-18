class Cube
  attr_reader :x, :y, :z, :number_of_neighbors
  def initialize(x,y,z)
    @x = x
    @y = y
    @z = z

    Cube.all << self
  end

  def find_number_of_neighbors
    cubes_without_self = Cube.all.reject { |c| c == self }
    neighbors = 0

    #xy
    xy_same = cubes_without_self.select { |cube| cube.x == @x && cube.y == @y }
    zp_free = xy_same.any? { |cube| cube.z == @z + 1) || cube.z == (@z - 1) }

    #xz
    xz_same = cubes_without_self.select { |cube| cube.x == @x && cube.z == @z }
    xz_ns = xz_same.count { |cube| cube.y == (@y + 1) || cube.y == (@y - 1) }

    #yz
    zy_same = cubes_without_self.select { |cube| cube.z == @z && cube.y == @y }
    zy_ns = zy_same.count { |cube| cube.x == (@x + 1) || cube.x == (@x - 1) }

    @number_of_neighbors = xy_ns + xz_ns + zy_ns
  end

  def self.all
    @@all ||= []
  end
end

def read_file(file)
  f = File.open(file, "r")
  f.each_line do |line|
    arr = line.strip.split(',').map(&:to_i)
    
    Cube.new(arr[0], arr[1], arr[2])
  end
end

use_input = true
file = use_input ? '2022/day_18/input.txt' : '2022/day_18/example.txt'
read_file(file)

puts Cube.all.inspect

total_neighbors = 0
Cube.all.each do |cube|
  total_neighbors += cube.find_number_of_neighbors
end

puts "neighbors #{total_neighbors}"
puts "cubes #{Cube.all.count}"
puts Cube.all.count * 6 - total_neighbors