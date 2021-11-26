trees_hit = 0
position = 0

ARGF.each_line do |line|
  arr = line.strip.split('')
  while position >= arr.length
    position -= arr.length
  end

  if arr[position] == '#'
    trees_hit += 1
  end

  position += 3
end

puts trees_hit