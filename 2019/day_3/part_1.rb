file='2019/day_3/input.txt'
directions = []

f = File.open(file, "r")
f.each_line do |line|
  directions << line.strip.split(',')
end

def move_right(point, distance)
  new_points = []
  distance.times do
    point = [point[0] + 1, point[1]]
    new_points << point
  end

  [point, new_points]
end

def move_left(point, distance)
  new_points = []
  distance.times do
    point = [point[0] - 1, point[1]]
    new_points << point
  end

  [point, new_points]
end

def move_up(point, distance)
  new_points = []
  distance.times do
    point = [point[0], point[1] + 1]
    new_points << point
  end

  [point, new_points]
end

def move_down(point, distance)
  new_points = []
  distance.times do
    point = [point[0], point[1] - 1]
    new_points << point
  end

  [point, new_points]
end

# @param directions [Array[String]] the R23 input
# @return [Array[Array[Integer]]] points on a map
def draw_map(direction_set)
  point = [0,0]
  map = [point]

  direction_set.each do |direction|
    distance = direction[1..-1].to_i
    case direction[0]
    when "R"
      point, new_points = move_right(point, distance)
    when "L"
      point, new_points = move_left(point, distance)
    when "U"
      point, new_points = move_up(point, distance)
    when "D"
      point, new_points = move_down(point, distance)
    else
      raise "unexpected input #{direction}"
    end

    map += new_points
  end

  map
end

def find_closest_distance(intersections)
  closest_distance = intersections.first[0].abs + intersections.first[1].abs

  intersections.each do |point|
    distance = point[0].abs + point[1].abs

    closest_distance = distance if distance < closest_distance
  end

  closest_distance
end

def solve(directions)
  map1 = draw_map(directions[0]).uniq
  map2 = draw_map(directions[1]).uniq

  intersections = map1 & map2
  intersections = intersections.reject { |i| i == [0,0] }
  
  puts find_closest_distance(intersections)
end

solve(directions)