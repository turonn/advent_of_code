file='2021/day_2/input.txt'
horizontal_position = 0
depth = 0
aim = 0

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split(' ')


  case arr[0]
  when 'forward'
    horizontal_position += arr[1].to_i
    depth += (aim * arr[1].to_i)
  when 'down'
    aim += arr[1].to_i
  when 'up'
    aim -= arr[1].to_i
  else
    puts "oops on #{line}"
  end
end

answer = horizontal_position * depth

puts answer