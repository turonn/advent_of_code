file='2021/day_15/input.txt'
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
  if (explore_pos[:v] + pos[:tentitive_distance]) < explore_pos[:tentitive_distance]
    map.delete_if { |p| p == explore_pos }

    explore_pos[:tentitive_distance] = (explore_pos[:v] + pos[:tentitive_distance])
    map << explore_pos

    map
  end

  map
end

def visit_position_and_look_around(map, pos)
  at_top = (pos[:y] == 0)
  at_bottom = (pos[:y] == map.max_by { |p| p[:y] }[:y])
  at_right_wall = (pos[:x] == map.max_by { |p| p[:x] }[:x])
  at_left_wall = (pos[:x] == 0)

  unless at_right_wall
    explore_pos = map.find { |p| (p[:x] == (pos[:x] + 1)) && (p[:y] == pos[:y]) }
    map = explore_new_pos(map, pos, explore_pos)
  end

  unless at_top
    explore_pos = map.find { |p| (p[:x] == pos[:x]) && (p[:y] == (pos[:y] - 1)) }
    map = explore_new_pos(map, pos, explore_pos)
  end

  unless at_left_wall
    explore_pos = map.find { |p| (p[:x] == (pos[:x] - 1)) && (p[:y] == pos[:y]) }
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

def find_path_score(map, start, goal)
  map, pos = find_starting_pos(map, start)

  while map.find { |p| (p[:x] == goal[0]) && (p[:y] == goal[1]) }[:visited] == false
    map = visit_position_and_look_around(map, pos)

    pos = find_shortest_path_pos(map)
  end

  map.find { |p| (p[:x] == goal[0]) && (p[:y] == goal[1])}[:tentitive_distance]
end

start = [0,0]
goal = [map.max_by { |p| p[:x] }[:x], map.max_by { |p| p[:y] }[:y]]
pp find_path_score(map, start, goal)