file='2021/day_7/input.txt'
number_of_lines = 0
starting_pos = {}

f = File.open(file, "r")
f.each_line do |line|
  starting_pos = line.strip.split(',').map(&:to_i).tally

end

min_key = 0
max_key = 0
starting_pos.each do |k, v|
  if k < min_key
    min_key = k
  end

  if k > max_key
    max_key = k
  end
end

end_pos = (min_key..max_key).to_a
def get_min_fule_needed(starting_pos, end_pos)
  min_fule = fule_needed_for_pos(starting_pos, end_pos.first)
  end_pos.each do |pos|
    fule = fule_needed_for_pos(starting_pos, pos)
    
    if fule < min_fule
      min_fule = fule
    end
  end
  min_fule
end

def fule_needed_for_pos(starting_pos, pos)
  fule_needed = 0
  starting_pos.each do |k, v|
    dist = (k-pos).abs
    next if dist == 0

    fule = (1..dist).to_a.inject(:+)
  end

  fule_needed
end

pp get_min_fule_needed(starting_pos, end_pos)