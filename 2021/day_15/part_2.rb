require 'rgl/adjacency'
require 'rgl/dijkstra'

file='2021/day_15/input.txt'
map = []
yv = 0

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split('').map(&:to_i)
  arr.each_with_index do |val, i|
    (0..4).to_a.each do |x_shift|
      v = val + x_shift
      map << {
        v: v > 9 ? v - 9 : v,
        x: i + (x_shift * arr.length),
        y: yv,
      }
    end
  end

  yv += 1
end

height = map.max_by { |p| p[:y] }[:y]
map2 = map.clone
map2.each do |p|
  (1..4).to_a.each do |y_shift|
    v = p[:v] + y_shift
    map << {
      v: v > 9 ? v - 9 : v,
      x: p[:x],
      y: p[:y] + (y_shift * (height+1)),
    }
  end
end

height = map.max_by { |p| p[:y] }[:y]
graph = RGL::DirectedAdjacencyGraph.new
(0..height).to_a.each do |x|
  (0..height).to_a.each do |y|
    graph.add_vertices(x.to_s + '.' + y.to_s)
  end
end

edge_weights = {}

map.each do |p|
  unless p[:x] == 0
    edge_weights[[(p[:x] - 1).to_s + '.' + p[:y].to_s, p[:x].to_s + '.' + p[:y].to_s]] = p[:v]
  end

  unless p[:y] == 0
    edge_weights[[p[:x].to_s + '.' + (p[:y] - 1).to_s, p[:x].to_s + '.' + p[:y].to_s]] = p[:v]
  end

  unless p[:x] == height
    edge_weights[[(p[:x] + 1).to_s + '.' + p[:y].to_s, p[:x].to_s + '.' + p[:y].to_s]] = p[:v]
  end

  unless p[:y] == height
    edge_weights[[p[:x].to_s + '.' + (p[:y] + 1).to_s, p[:x].to_s + '.' + p[:y].to_s]] = p[:v]
  end
end

edge_weights.each { |(x, y), v| graph.add_edge(x, y) }

path = graph.dijkstra_shortest_path(edge_weights, "0.0", "#{height}.#{height}")

risk = 0
first = true
path.map do |p|
  a = p.split('.').map(&:to_i)

  if first
    first = false
    next
  end

  vert = map.find { |v| (v[:x] == a[0]) && (v[:y] == a[1])}
  risk += vert[:v]
end

pp risk