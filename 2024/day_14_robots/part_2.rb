require 'matrix'

class Robot
  attr_reader :x, :y

  def initialize(x, y, vx, vy)
    @x = x
    @y = y
    @vx = vx
    @vy = vy
  end

  def move(seconds)
    @x = (@x + (@vx * seconds)) % Map::WIDTH
    @y = (@y + (@vy * seconds)) % Map::HEIGHT
    self
  end
end

class Map
  WIDTH = 101
  HEIGHT = 103

  attr_reader :second

  def initialize(robots)
    @robots = robots
    @map = Matrix.build(103, 101) { "." }
    @second = 0
  end

  def start(second)
    @second += second
    @robots.map { |r| r.move(second) }
  end

  def move_one_second
    @map = Matrix.build(103, 101) { "." }
    @robots.map { |r| r.move(1) }
    @second += 1
    self
  end

  def draw_map
    @robots.each do |robot|
      @map[robot.y, robot.x] = 'X'
    end
    @map.to_a.each do |row|
      puts row.join(" ")
    end
  end

  def clustered_robots?
    row_robots = {}
    @robots.each do |robot|
      row_robots[robot.x] ||= 0
      row_robots[robot.x] += 1
    end

    # does any row have more than 30 robots on it?
    row_robots.any? { |_pos, count| count > 30 }
  end
end

robots = []

file = '2024/day_14_robots/input.txt'
f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split(' ')
  pos = arr[0].split(',')
  vol = arr[1].split(',')

  robots << Robot.new(pos[0][2..-1].to_i, pos[1].to_i, vol[0][2..-1].to_i, vol[1].to_i) 
end

map = Map.new(robots)

while true
  map.move_one_second
  if map.clustered_robots?
    pp map.second
    map.draw_map
  end
end