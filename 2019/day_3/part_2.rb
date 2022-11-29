file='2019/day_3/input.txt'
directions = []

f = File.open(file, "r")
f.each_line do |line|
  directions << line.strip.split(',')
end

Point = Struct.new(:coords, :steps, keyword_init: true)

def move_right(point, distance, steps)
  new_points = []
  distance.times do
    steps += 1
    point = [point[0] + 1, point[1]]
    new_points << Point.new(:coords => point, :steps => steps)
  end

  [point, new_points, steps]
end

def move_left(point, distance, steps)
  new_points = []
  distance.times do
    steps += 1
    point = [point[0] - 1, point[1]]
    new_points << Point.new(:coords => point, :steps => steps)
  end

  [point, new_points, steps]
end

def move_up(point, distance, steps)
  new_points = []
  distance.times do
    steps += 1
    point = [point[0], point[1] + 1]
    new_points << Point.new(:coords => point, :steps => steps)
  end

  [point, new_points, steps]
end

def move_down(point, distance, steps)
  new_points = []
  distance.times do
    steps += 1
    point = [point[0], point[1] - 1]
    new_points << Point.new(:coords => point, :steps => steps)
  end

  [point, new_points, steps]
end

# @param directions [Array[String]] the R23 input
# @return [Array[Array[Integer]]] points on a map
def draw_map(direction_set)
  point = [0,0]
  steps = 0
  map = [Point.new(:coords => point, :steps => steps)]

  direction_set.each do |direction|
    distance = direction[1..-1].to_i
    case direction[0]
    when "R"
      point, new_points, steps = move_right(point, distance, steps)
    when "L"
      point, new_points, steps = move_left(point, distance, steps)
    when "U"
      point, new_points, steps = move_up(point, distance, steps)
    when "D"
      point, new_points, steps = move_down(point, distance, steps)
    else
      raise "unexpected input #{direction}"
    end

    map += new_points
  end

  map
end

def remove_duplicate_points(map, intersection_coordinates)
  points = map.select { |point| intersection_coordinates.include?(point.coords) && point.coords != [0,0] }

  points.map do |point|
    points.select { |p| point.coords == p.coords }.min_by(&:steps)
  end.uniq
end

def find_intersections(map1, map2)
  intersections = []
  map2_coords = map2.map(&:coords)
  map1.each do |point1|
    if map2_coords.include?(point1.coords)
      point2 = map2.detect { |point2| point2.coords == point1.coords }

      intersections << [point1, point2]
    end
  end

  intersections
end

def find_intersection_coordinates(map1, map2)
  map1_coords = map1.map(&:coords).uniq
  map2_coords = map2.map(&:coords).uniq
  
  map1_coords & map2_coords
end

def solve(directions)
  map1 = draw_map(directions[0])
  map2 = draw_map(directions[1])

  intersection_coordinates = find_intersection_coordinates(map1, map2)

  map1_points = remove_duplicate_points(map1, intersection_coordinates)
  map2_points = remove_duplicate_points(map2, intersection_coordinates)

  intersections = find_intersections(map1_points, map2_points)

  puts intersections.flat_map { |points| points.map(&:steps).sum }.min
end

solve(directions)