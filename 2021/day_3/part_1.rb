file='2021/day_3/input.txt'
number_of_lines = 0
counter = []

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split('')
  number_of_lines += 1

  arr.each_with_index do |d, i|
    if counter[i] 
      counter[i] += d.to_i
    else
      counter[i] = d.to_i
    end
  end
end

gamma = []
epsilon = []
counter.each do |i|
  if i > (number_of_lines/2)
    gamma << 1
    epsilon << 0
  else
    gamma << 0
    epsilon << 1
  end
end

gamma = gamma.join('').to_i(2)
epsilon = epsilon.join('').to_i(2)

puts gamma * epsilon