file='2021/day_1/input.txt'
number_of_increases = 0
previous_number = 0

f = File.open(file, "r")
f.each_line do |line|
  if line.strip.to_i > previous_number
    number_of_increases += 1
  end
  previous_number = line.strip.to_i
end

puts number_of_increases - 1