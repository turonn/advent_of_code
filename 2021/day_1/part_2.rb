file='2021/day_1/input.txt'
number_of_increases = 0
previous_numbers = [0,0,0]
previous_sum = 0

f = File.open(file, "r")
f.each_line do |line|
  current_numbers = previous_numbers[1..2]
  current_numbers << line.strip.to_i
  current_sum = current_numbers.inject(:+)

  if current_sum > previous_sum
    number_of_increases += 1
  end

  previous_sum = current_sum
  previous_numbers = current_numbers
end

puts number_of_increases - 3