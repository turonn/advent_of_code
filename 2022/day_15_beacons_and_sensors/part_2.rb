class Map
  attr_reader :map

  def initialize(sensors, beacons)
    @sensors = sensors
    @beacons = beacons
  end

  def find_coverages_upto_row(max_row_num)
    (0..max_row_num).map do |row_num|
      _find_coverage_for_row(row_num, max_row_num)      
    end
  end

  private  

  def _find_coverage_for_row(row_num, max_row_num)
    sensors = _sensors_that_cross_row(row_num)

    ranges = sensors.map do |sensor|
      _scoped_range_covered_by_sensor(sensor, row_num, max_row_num)
    end

    final_ranges = []
    sorted_ranges = ranges.sort
    sorted_ranges.each_with_index do |r,i|
      next final_ranges = [r] if i == 0

      # we can do minus one because they don't have to overlap
      if (r[0] - 1) <= final_ranges[-1][1]
        new_max = [r[1], final_ranges[-1][1]].max
        final_ranges[-1] = [final_ranges[-1][0], new_max]
      else
        "pushed"
        final_ranges << r
      end
    end
    final_ranges
  end

  def _scoped_range_covered_by_sensor(sensor, row_num, max_row)
    width = (sensor.radius - (row_num - sensor.y).abs) * 2 + 1
    
    start = sensor.x - width/2 
    start = 0 if start < 0
    start = max_row if start > max_row
    finish = sensor.x + width/2
    finish = 0 if finish < 0
    finish = max_row if finish > max_row

    [start, finish]
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


max_row = 4000000
coverages = map.find_coverages_upto_row(max_row)

coverages.each_with_index do |ranges, y_value|
  next if ranges == [[0,max_row]]
  
  puts (ranges[0][1] + 1) * max_row + y_value
  break
end

