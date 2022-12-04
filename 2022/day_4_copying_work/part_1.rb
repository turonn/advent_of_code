file='2022/day_4/input.txt'
number_of_lines = 0
pairs_ranges = []

f = File.open(file, "r")
f.each_line do |line|
  pairs = line.strip.split(',')

  first_range = pairs[0].split('-').map(&:to_i)
  second_range = pairs[1].split('-').map(&:to_i)
  
  pairs_ranges << [first_range, second_range]
end

def is_inside?(outer_range, inner_range)
  return false unless outer_range[0] <= inner_range[0]
  return false unless outer_range[1] >= inner_range[1]
  true
end

count = 0
pairs_ranges.each do |pair_ranges|
  if is_inside?(pair_ranges[0], pair_ranges[1])
    count += 1
  else
    count += 1 if is_inside?(pair_ranges[1], pair_ranges[0])
  end
end

puts count