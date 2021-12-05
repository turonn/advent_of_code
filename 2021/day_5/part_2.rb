require 'matrix'

file='2021/day_5/input.txt'
lines = []
largest_x = 0
largest_y = 0

def check_line_endpoints_for_larger_values(line_endpoints, largest_x, largest_y)
  largest_x = [line_endpoints[:start][0], line_endpoints[:finish][0], largest_x].max
  largest_y = [line_endpoints[:start][1], line_endpoints[:finish][1], largest_y].max
  
  [largest_x, largest_y]
end

f = File.open(file, "r")
f.each_line do |line|
  line_endpoints = {}
  arr = line.strip.split(' -> ')

  line_endpoints[:start] = arr[0].split(',').map { |cord| cord.to_i }
  line_endpoints[:finish] = arr[1].split(',').map { |cord| cord.to_i }

  largest_x, largest_y = check_line_endpoints_for_larger_values(line_endpoints, largest_x, largest_y)
  
  lines << line_endpoints
end

map = Matrix.build(largest_x + 1, largest_y + 1) { 0 }

def get_line_points_for_horz_or_vert(line_endpoints)
  if line_endpoints[:start][0] == line_endpoints[:finish][0]
    y_ends = [line_endpoints[:start][1], line_endpoints[:finish][1]].sort
    y_vals = (y_ends[0]..y_ends[1]).to_a
    line_points = y_vals.map { |y| [line_endpoints[:start][0], y]}
  else
    x_ends = [line_endpoints[:start][0], line_endpoints[:finish][0]].sort
    x_vals = (x_ends[0]..x_ends[1]).to_a
    line_points = x_vals.map { |x| [x, line_endpoints[:start][1]]}
  end

  line_points
end

def get_line_points_for_pos_slope(line_endpoints, diff)
  line_points = []
  x_start = [line_endpoints[:start][0], line_endpoints[:finish][0]].sort.first
  y_start = [line_endpoints[:start][1], line_endpoints[:finish][1]].sort.first
  (0..diff[0].abs).to_a.each do |i|
    point = [x_start + i, y_start + i]
    line_points << point
  end

  line_points
end

def get_line_points_for_neg_slope(line_endpoints, diff)
  line_points = []
  x_start = [line_endpoints[:start][0], line_endpoints[:finish][0]].sort.first
  y_start = [line_endpoints[:start][1], line_endpoints[:finish][1]].sort[1]
  (0..diff[0].abs).to_a.each do |i|
    point = [x_start + i, y_start - i]
    line_points << point
  end

  line_points
end

def get_line_points_from_endpoints(line_endpoints)
  diff = [line_endpoints[:start][0] - line_endpoints[:finish][0], line_endpoints[:start][1] - line_endpoints[:finish][1]]

  if diff.include?(0)
    return get_line_points_for_horz_or_vert(line_endpoints)

  elsif diff[0] == diff[1]
    return get_line_points_for_pos_slope(line_endpoints, diff)

  else
    return get_line_points_for_neg_slope(line_endpoints, diff)
  end
end

def draw_line_on_map(map, line_points)
  line_points.each do |point|
    map[point[0], point[1]] += 1
  end
  map
end

def find_number_of_safe_points(map)
  map.count { |v| v > 1 }
end

def find_answer(map, lines)
  lines.each do |line_endpoints|
    line_points = get_line_points_from_endpoints(line_endpoints)
    map = draw_line_on_map(map, line_points)
  end
  find_number_of_safe_points(map)
end

pp find_answer(map, lines)