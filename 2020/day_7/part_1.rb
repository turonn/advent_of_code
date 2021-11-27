file='2020/day_7/input.txt'
bag_rules = {}
lead_to_sgb = ['shiny gold bag']

def strip_space_and_s(arr)
  arr.map do |value|
    nv = value.strip
    if value[-1] == 's'
      nv = nv[0..-2]
    end
    nv
  end
end

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split('s contain ')
  next if arr[1] == 'no other bags.'

  key = arr[0]
  values = arr[1].tr('0-9.', '').split(',')

  bags = strip_space_and_s(values)

  bag_rules[key] = bags
end

previous_size = 0

while bag_rules.size != previous_size
  previous_size = bag_rules.size
  old_rules = bag_rules

  old_rules.each do |k, bags|
    if bags.any? { |bag| lead_to_sgb.include?(bag) }
      lead_to_sgb << k
      bag_rules.delete(k)
    end
  end
end

puts lead_to_sgb.count - 1