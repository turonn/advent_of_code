file='2021/day_14/example.txt'
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

def take_one_step(polymer, rules)
  pol_arr = polymer.split('')
  shift = 0
  bank = []

  pol_arr.each_with_index do |char, i|
    bank << char
    next if bank.size == 1
    
    key = bank.join('')
    rule = rules.find { |r| r[:cond] == key }

    if rule
      polymer.insert((i+shift), rule[:val]) 
      shift += 1
    end
    bank = bank.drop(1)
  end
  
  polymer
end

def insert_vals_into_polymer(polymer, vals)
  vals.sort_by { |v| v[:index] }.reverse.each do |v|
    polymer.insert(v[:index], v[:val])
  end

  polymer
end

def difference_between_max_min(polymer)
  p = polymer.split('')
  counts = p.uniq

  counts = counts.map do |char|
    {
      char: char,
      count: p.count(char)
    }
  end

  max = counts.max_by { |c| c[:count] }
  min = counts.min_by { |c| c[:count] }

  max[:count] - min[:count]
end

def find_answer_after_given_steps(polymer, rules, steps)
  steps.times do
    polymer = take_one_step(polymer, rules)
  end

  difference_between_max_min(polymer)
end

pp find_answer_after_given_steps(polymer, rules, 10)