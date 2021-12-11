require 'matrix'

file='2021/day_11/input.txt'
map = []
y = 0
f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split('')

  arr.each_with_index do |v, x|
    map << {
      x: x,
      y: y,
      v: v.to_i,
      f: false
    }
  end
  y += 1
end

def advance_one_step(map, flashes)
  map = map.map do |hash|
    {
      x: hash[:x],
      y: hash[:y],
      v: hash[:v] + 1,
      f: hash[:f]
    }
  end

  map = flash(map)

  map = map.map do |hash|
    if hash[:f]
      flashes += 1
      h = {
        x: hash[:x],
        y: hash[:y],
        v: 0,
        f: false
      }
    else
      h = hash
    end
    h
  end
  [map, flashes]
end

def flash(map)
  map, flashes = cycle_through(map)
  while flashes > 0
    map, flashes = cycle_through(map)
  end
  map
end

def cycle_through(map)
  flashes = 0
  map.each do |hash|
    if (hash[:v] > 9) && (hash[:f] == false)
      flashes += 1
      map = flip_self_and_adjacent(map, hash[:x], hash[:y])
      break
    end
  end
  [map, flashes]
end

def flip_self_and_adjacent(map, x, y)
  adjacent = map.select do |hash|
    ((hash[:x] == x) && (hash[:y] == (y - 1))) ||
      ((hash[:x] == x) && (hash[:y] == (y + 1))) ||
      ((hash[:x] == (x - 1)) && (hash[:y] == y)) ||
      ((hash[:x] == (x - 1)) && (hash[:y] == (y - 1))) ||
      ((hash[:x] == (x - 1)) && (hash[:y] == (y + 1))) ||
      ((hash[:x] == (x + 1)) && (hash[:y] == y)) ||
      ((hash[:x] == (x + 1)) && (hash[:y] == (y - 1))) ||
      ((hash[:x] == (x + 1)) && (hash[:y] == (y + 1)))
  end

  map.map do |hash|
    if adjacent.include?(hash)
      h = {
        x: hash[:x],
        y: hash[:y],
        v: hash[:v] + 1,
        f: hash[:f]
      }
    elsif ((hash[:x] == x) && (hash[:y] == y))
      h = {
        x: hash[:x],
        y: hash[:y],
        v: hash[:v],
        f: true
      }
    else
      h = hash
    end
    h
  end
end

def get_steps_to_syncronize_flashes(map)
  flashes = 0
  steps = 0
  while flashes < 100
    map, flashes = advance_one_step(map, 0)
    steps += 1
  end
  steps
end

pp get_steps_to_syncronize_flashes(map)