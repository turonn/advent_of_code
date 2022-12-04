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

def is_overlap?(left_range, right_range)
  return true if left_range[1] >= right_range[0]
  false
end

count = 0
pairs_ranges.each do |pair_ranges|
  if is_inside?(pair_ranges[0], pair_ranges[1])
    count += 1
    next
  elsif is_inside?(pair_ranges[1], pair_ranges[0])
    count += 1
    next
  end

  ordered_pairs = pair_ranges.sort_by { |r| r[0] }
  count += 1 if is_overlap?(ordered_pairs[0], ordered_pairs[1])
end

puts count