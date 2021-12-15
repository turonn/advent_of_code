file='2021/day_15/example.txt'
map = []
yv = 0

f = File.open(file, "r")
f.each_line do |line|
  line.strip.split('').each_with_index do |val, i|
    map << {
      v: val.to_i,
      x: i,
      y: yv,
      tentitive_distance: Float::INFINITY,
      visited: false
    }
  end

  yv += 1
end

def explore_new_pos(map, pos, explore_pos)
  pp 'x'
  pp map
  pp pos
  pp explore_pos

  if (explore_pos[:v] + pos[:tentitive_distance]) < explore_pos[:tentitive_distance]
    map.delete_if { |p| p == explore_pos }

    explore_pos[:tentitive_distance] = (explore_pos[:v] + pos[:tentitive_distance])
    map << explore_pos

    map
  end

  map
end

def find_shifts(x, y, orig_max)
  x_shift = (x / (orig_max + 1)).floor
  y_shift = (y / (orig_max + 1)).floor

  [x_shift, y_shift]
end

def visit_position_and_look_around(map, pos, orig_max)
  at_bottom = (pos[:y] == map.max_by { |p| p[:y] }[:y])
  at_right_wall = (pos[:x] == map.max_by { |p| p[:x] }[:x])

  if at_right_wall
    unless pos[:x] == ((orig_max + 1) * 5 - 1)
      x_shift, y_shift = find_shifts(pos[:x] + 1, pos[:y], orig_max)

      rows_to_copy = map.select { |p| (p[:y] >= (pos[:y] - (y_shift * (orig_max + 1)))) && (p[:x] <= orig_max) }

      rows_to_copy.each do |p|
        new_val = p[:v] + x_shift + y_shift
        map << {
          v: new_val > 9 ? (new_val - 9) : new_val,
          x: p[:x] + ((orig_max + 1) * x_shift),
          y: p[:y] + ((orig_max + 1) * y_shift),
          tentitive_distance: Float::INFINITY,
          visited: false
        }
      end
      pp map
      at_right_wall = false
    end
  end

  if at_bottom
    unless pos[:x] == ((orig_max + 1) * 5 - 1)
      x_shift, y_shift = find_shifts(pos[:x], pos[:y] + 1, orig_max)

      columns_to_copy = map.select { |p| (p[:x] >= (pos[:x] - (x_shift * (orig_max + 1)))) && (p[:y] <= orig_max) }

      columns_to_copy.each do |p|
        new_val = p[:v] + x_shift + y_shift
        map << {
          v: new_val > 9 ? (new_val - 9) : new_val,
          x: p[:x] + ((orig_max + 1) * x_shift),
          y: p[:y] + ((orig_max + 1) * y_shift),
          tentitive_distance: Float::INFINITY,
          visited: false
        }
      end

      at_bottom = false
    end
  end

  unless at_right_wall
    explore_pos = map.find { |p| (p[:x] == (pos[:x] + 1)) && (p[:y] == pos[:y]) }
    map = explore_new_pos(map, pos, explore_pos)
  end

  unless at_bottom
    explore_pos = map.find { |p| (p[:x] == pos[:x]) && (p[:y] == (pos[:y] + 1)) }
    map = explore_new_pos(map, pos, explore_pos)
  end

  visit_position(map, pos)
end

def visit_position(map, pos)
  map.delete_if { |p| p == pos }

  pos[:visited] = true
  map << pos

  map
end

def find_shortest_path_pos(map)
  unvisited = map.select { |p| p[:visited] == false }

  unvisited.min_by{ |p| p[:tentitive_distance] }
end

def find_starting_pos(map, start)
  pos = map.find { |p| (p[:x] == start[0]) && (p[:y] == start[1])}
  map.delete_if { |p| p == pos }

  pos[:tentitive_distance] = 0
  map << pos

  [map, pos]
end

def find_path_score(map, start, orig_goal)
  map, pos = find_starting_pos(map, start)
  new_goal = [((orig_goal[0] + 1) * 5 - 1), ((orig_goal[1] + 1) * 5 - 1)]

  goal_dot = nil

  while goal_dot.nil? || goal_dot[:visited] == false
    map = visit_position_and_look_around(map, pos, orig_goal[0])

    pos = find_shortest_path_pos(map)

    goal_dot = map.find { |p| (p[:x] == new_goal[0]) && (p[:y] == new_goal[1]) }
  end

  goal_dot[:tentitive_distance]
end

start = [0,0]
orig_goal = [map.max_by { |p| p[:x] }[:x], map.max_by { |p| p[:y] }[:y]]
pp find_path_score(map, start, orig_goal)