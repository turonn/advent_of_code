class Map
  attr_reader :map

  def initialize(sensors, beacons)
    @sensors = sensors
    @beacons = beacons
    _set_width_and_x_offset
  end

  def draw_relevant_row(row_num)
    sensors = _sensors_that_cross_row(row_num)

    row = Array.new(@width, ".")

    sensors.each do |sensor|
      row = _plot_overlap_on_row(sensor, row, row_num)
    end

    row
  end

  private

  def _plot_overlap_on_row(sensor, row, row_num)
    width = (sensor.radius - (row_num - sensor.y).abs) * 2 + 1
    center = sensor.x + @x_offset
    
    x_start = center - width/2 

    width.times do |i|
      r_index = x_start + i
      next if r_index.negative?
      break if r_index > @width - 1
      
      row[r_index] = "#"
    end

    beacons = @beacons.select { |b| b.y == row_num }

    beacons.each do |beacon|
      row[beacon.x + @x_offset] = "B"
    end

    sensors = @sensors.select { |s| s.y == row_num }

    sensors.each do |sensor|
      row[sensor.x + @x_offset] = "S"
    end

    row
  end

  def _set_width_and_x_offset
    x_max = (@sensors.map {|s| s.x + s.radius}).max
    x_min = (@sensors.map {|s| s.x - s.radius}).min

    puts "x min #{x_min}"
    puts "x max #{x_max}"

    @x_offset = x_min.abs
    @width = x_max - x_min
  end

  def _sensors_that_cross_row(row_num)
    @sensors.select do |sensor|
      sensor.y == row_num ||
        (sensor.y < row_num && (sensor.y + sensor.radius) >= row_num) ||
        (sensor.y > row_num && (sensor.y - sensor.radius) <= row_num)
    end
  end
end

class Sensor
  attr_reader :x, :y, :radius
  def initialize(y, x, closest_beacon)
    @y = y
    @x = x
    @closest_beacon = closest_beacon
    _set_radius
  end

  private
  def _set_radius
    @radius = (@x - @closest_beacon.x).abs + (@y - @closest_beacon.y).abs
  end
end

class Beacon
  attr_reader :x, :y

  def initialize(y, x)
    @y = y
    @x = x
  end
end

def read_file(file)
  sensors = []
  beacons = []
  f = File.open(file, "r")
  f.each_line do |line|
    arr = line.strip.split(' ')
    b_x = arr[8].split('=')[1].delete!(",").to_i
    b_y = arr[9].split('=')[1].to_i
    beacon = Beacon.new(b_y, b_x)

    s_x = arr[2].split('=')[1].delete!(",").to_i
    s_y = arr[3].split('=')[1].delete!(":").to_i
    sensor = Sensor.new(s_y, s_x, beacon)

    beacons << beacon
    sensors << sensor
  end

  Map.new(sensors, beacons)
end

use_input = true
file = use_input ? '2022/day_15/input.txt' : '2022/day_15/example.txt'
map = read_file(file)

# puts map.inspect
puts map.draw_relevant_row(2000000).count { |i| i == '#'}


# input min/max
# x -7488,4559391
# y -1160614,4058847