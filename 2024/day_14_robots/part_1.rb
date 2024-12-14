class Robot
  WIDTH = 101
  HEIGHT = 103

  attr_reader :quadrant

  def initialize(x, y, vx, vy)
    @x = x
    @y = y
    @vx = vx
    @vy = vy
    @quadrant = nil
  end

  def move(seconds)
    @x = (@x + (@vx * seconds)) % WIDTH
    @y = (@y + (@vy * seconds)) % HEIGHT
    @quadrant = _quadrant
    self
  end

  private

  def _quadrant
    return nil if @x == WIDTH / 2
    return nil if @y == HEIGHT / 2

    if @x < WIDTH / 2
      if @y < HEIGHT / 2
        1
      else
        2
      end
    else
      if @y < HEIGHT / 2
        3
      else
        4
      end
    end
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

score = 0
quadrants = []
robots.map { |r| r.move(100) }.group_by(&:quadrant).each do |quadrant, robots| 
  next if quadrant.nil?
  quadrants << robots.size
end

pp quadrants.inject(&:*)