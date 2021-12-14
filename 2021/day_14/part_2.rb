file='2021/day_14/input.txt'
polymer = nil
first = true
rules = []

f = File.open(file, "r")
f.each_line do |line|
  if first
    polymer = line.strip
    first = false
    next
  end

  next if line.strip.empty?

  arr = line.strip.split(' -> ')

  rules << {
    cond: arr[0],
    val: arr[1]
  }
end

def take_one_step(poly_pairs, rules, counts)
  iter = poly_pairs.clone
  iter.each do |k, v|
    next if v == 0
    rule = rules.find { |r| r[:cond] == k }
    
    if rule.nil?
      poly_pairs = poly_pairs.reject { |kk, vv| kk == k }
    else
      counts[rule[:val]] ||= 0
      counts[rule[:val]] += v

      poly_pairs[k[0] + rule[:val]] ||= 0
      poly_pairs[k[0] + rule[:val]] += v
      poly_pairs[rule[:val] + k[1]] ||= 0
      poly_pairs[rule[:val] + k[1]] += v

      poly_pairs[k] -= v
    end
  end
  
  poly_pairs = poly_pairs.reject { |k, v| v < 1 }

  [poly_pairs, counts]
end

def get_initial_counts(polymer)
  counts = {}
  polymer.split('').each do |char|
    counts[char] ||= 0
    counts[char] += 1
  end

  counts
end

def get_initial_pairs(polymer)
  p = polymer.split('')
  poly_pairs = {}
  bank = []

  p.each do |char|
    bank << char
    next if bank.size == 1

    poly_pairs[bank.join('')] ||= 0
    poly_pairs[bank.join('')] += 1
    bank = bank.drop(1)
  end

  poly_pairs
end

def find_answer_after_given_steps(polymer, rules, steps)
  counts = get_initial_counts(polymer)
  poly_pairs = get_initial_pairs(polymer)

  steps.times do
    poly_pairs, counts = take_one_step(poly_pairs, rules, counts)
  end
  
  max = counts.max_by { |k, v| v }
  min = counts.min_by { |k, v| v }

  max[1] - min[1]
end

pp find_answer_after_given_steps(polymer, rules, 40)
