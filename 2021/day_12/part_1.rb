file='2021/day_12/input.txt'
starting_points = []
caves = []

f = File.open(file, "r")
f.each_line do |line|
  cave = {}
  arr = line.strip.split('-')
  
  cave0 = caves.select { |c| c[:name] == arr[0] }
  cave1 = caves.select { |c| c[:name] == arr[1] }

  if cave0.empty?
    caves << {
      name: arr[0],
      neighbors: [arr[1]],
      small: arr[0].downcase == arr[0]
    }
  else
    caves = caves.map do |cave|
      if cave0.include?(cave)
        {
          name: cave[:name],
          neighbors: cave[:neighbors] << arr[1],
          small: cave[:small]
        }
      else
        cave
      end
    end
  end

  if cave1.empty?
    caves << {
      name: arr[1],
      neighbors: [arr[0]],
      small: arr[1].downcase == arr[1]
    }
  else
    caves = caves.map do |cave|
      if cave1.include?(cave)
        {
          name: cave[:name],
          neighbors: cave[:neighbors] << arr[0],
          small: cave[:small]
        }
      else
        cave
      end
    end
  end
end

def valid_neighbors(caves, cave, visited_caves)
  neighbor_caves = caves.select { |c| cave[:neighbors].include?(c[:name]) }

  return neighbor_caves if (visited_caves.nil? || visited_caves.empty?)

  neighbor_caves.reject do |n_c|
    n_c[:small] && visited_caves.include?(n_c)
  end
end

def visit_cave_and_see_if_finished(caves, cave, paths, visited_caves)
  visited_caves << cave
  valid_neighbors = valid_neighbors(caves, cave, visited_caves)
  
  if cave[:neighbors].include?('end')
    paths += 1
  end
  
  return [visited_caves[0..-1], paths] if (valid_neighbors.count == 0 || valid_neighbors.nil?)    

  valid_neighbors.each do |c|
    visited_caves, paths = visit_cave_and_see_if_finished(caves, c, paths, visited_caves)
    visited_caves = visited_caves[0..-2]
  end

  [visited_caves, paths]
end

def find_number_of_paths(caves)
  start_cave = caves.find { |c| c[:name] == 'start' }
  end_cave = caves.find { |c| c[:name] == 'end' }
  starting_caves = caves.select { |c| start_cave[:neighbors].include?(c[:name]) }

  paths = 0
  starting_caves.each do |cave|
    visited_caves, n_paths = visit_cave_and_see_if_finished(caves, cave, 0, [start_cave, end_cave])
    paths += n_paths
  end
  paths
end

pp find_number_of_paths(caves)
