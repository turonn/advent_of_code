file='2020/day_3/day_3_input.txt'
answer = []
slopes = [
  {
    right: 1,
    down: 1
  },
  {
    right: 3,
    down: 1
  },
  {
    right: 5,
    down: 1
  },
  {
    right: 7,
    down: 1
  },
  {
    right: 1,
    down: 2
  }
]

slopes.each do |slope|
  trees_hit = 0
  position = 0
  line_count = -1

  f = File.open(file, "r")

  f.each_line do |line|
    line_count += 1
    next if (line_count % slope[:down]) != 0

    arr = line.strip.split('')
    while position >= arr.length
      position -= arr.length
    end

    if arr[position] == '#'
      trees_hit += 1
    end

    position += slope[:right]
  end

  f.close

  answer << trees_hit
end

puts answer.inject(:*)